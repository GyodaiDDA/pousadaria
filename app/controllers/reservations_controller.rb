class ReservationsController < ApplicationController
  before_action :set_room, only: %i[index new]
  before_action :set_reservation, only: %i[show edit update]
  before_action :set_reservations, only: %i[index]
  before_action :cpf?, only: %i[edit update]

  def index; end

  def new
    @reservation = Reservation.new
  end

  def show; end

  def create
    @reservation = Reservation.new(consultation_params)
    @reservation.status = Reservation.available?(consultation_params)
    @reservation.user_id = current_user.id if current_user
    @reservation.total_value = set_value

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
    if @reservation.update(confirmation_params)
      redirect_to room_reservation_path(@reservation.room, @reservation), notice: "Sua reserva foi realizada. Em breve, a #{@reservation.room.inn.brand_name} entrará em contato com você."
    else
      flash[:notice] = 'Não foi possível confirmar sua reserva.'
      render edit
    end
  end

  private

  def save_to_session_if_user_unknown
    return unless @reservation
    return unless @reservation.user_id

    session[:codes] = [] unless session[:codes]
    session[:codes] << @reservation.code
  end

  def set_reservations
    user_reservations = current_user ? Reservation.where(user_id: current_user.id, room_id: @room.id, status: 'available') : []
    session_reservations = session[:codes].present? ? Reservation.where(code: session[:codes], room_id: @room.id) : []
    (user_reservations + session_reservations).uniq
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
    @room = @reservation.room
  end

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end

  def set_value
    (@reservation.end_date - @reservation.start_date) * @reservation.room.base_price
  end

  def consultation_params
    params.require(:reservation)
          .permit(:start_date, :end_date, :guests, :room_id)
  end

  def confirmation_params
    params.require(:reservation)
          .permit(:code, :guests, :value, :user_id, :status)
  end
end