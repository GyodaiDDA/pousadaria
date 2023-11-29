class ReservationsController < ApplicationController
  before_action :set_room, only: %i[new create]
  before_action :set_reservation, only: %i[show edit update]

  def list
    return unless current_user

    @reservations = ReservationsSelector.new({ user: current_user }).find
  end

  def show; end

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_params)
    PriceCalculator.new(@reservation).estimate

    if @reservation.save
      if @reservation.status == 'available'
        save_to_session_if_user_unknown
        redirect_to room_reservation_path(@reservation.room, @reservation), notice: 'Legal! Quarto disponível para esta reserva.'
      else
        redirect_to room_path(@reservation.room_id), notice: 'Que pena! Quarto indisponível para esta reserva.'
      end
    else
      flash[:alert] = 'Ocorreu um problema no processamento da sua consulta.'
      render 'new'
    end
  end

  def edit; end

  def update
    if @reservation.update(update_params)
      StatusChange.new.procedure(@reservation, update_params)
      flash[:notice] = MessageService.new.reservation_status_update(@reservation)
      redirect_to room_reservation_path(@reservation.room, @reservation)
    else
      flash.now[:alert] = 'Não foi possível alterar a reserva.'
      render 'show'
    end
  end

  def retrieve
    @session_reservations = session[:codes].present? ? Reservation.where(code: session[:codes]) : []
  end

  def reclaim
    if @reservation.update(user_params)
      redirect_to room_reservation_path(@reservation.room, @reservation)
    else
      flash[:notice] = 'Não foi possível confirmar sua reserva.'
      render 'retrieve'
    end
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
    @owner_view = the_owner?(@reservation.room.inn)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def save_to_session_if_user_unknown
    return unless @reservation
    return if @reservation.user_id

    session[:codes] = [] if session[:codes].blank?
    session[:codes] << @reservation.code
  end

  def reservation_params
    params.require(:reservation)
          .permit(:start_date, :end_date, :guests, :room_id, :user_id)
  end

  def user_params
    params.require(:reservation)
          .permit(:user_id)
  end

  def update_params
    params.require(:reservation)
          .permit(:status, :payment)
  end
end
