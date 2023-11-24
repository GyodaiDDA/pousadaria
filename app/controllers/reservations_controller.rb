class ReservationsController < ApplicationController
  before_action :set_room, only: %i[index new create]
  before_action :set_reservation, only: %i[show edit update]
  before_action :set_room_reservations, only: %i[index]
  before_action :cpf?, only: %i[edit update]

  def index; end

  def list
    return unless current_user

    @reservations = check_expiration(Reservation.where(user_id: current_user.id))
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
    return redirect_by_status if @reservation.update(update_params)

    flash.now[:alert] = 'Não foi possível alterar a reserva.'
    render 'show'
  end

  def retrieve
    @session_reservations = session[:codes].present? ? Reservation.where(code: session[:codes]) : []
  end

  def reclaim
    @reservation.user_id = params[:user_id]
    if @reservation.update(user_params)
      redirect_to room_reservation_path(@reservation.room, @reservation)
    else
      flash[:notice] = 'Não foi possível confirmar sua reserva.'
      render 'retrieve'
    end
  end

  private

  def save_to_session_if_user_unknown
    return unless @reservation
    return if @reservation.user_id

    session[:codes] = [] unless session[:codes]
    session[:codes] << @reservation.code
  end

  def set_room_reservations
    @reservations = Reservation.where(room_id: @room.id, status: 'available')
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
    @owner_view = the_owner?(@reservation.room.inn)
  end

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end

  def check_expiration(reservations)
    reservations.each do |reservation|
      reservation.update(status: 'expired') if reservation.status == 'available' && reservation.start_date < Time.zone.tomorrow
    end
  end

  def redirect_by_status
    case @reservation.status
    when 'confirmed'
      redirect_to room_reservation_path(@reservation.room, @reservation), notice: "Sua reserva foi realizada. Em breve, a #{@reservation.room.inn.brand_name} entrará em contato com você."
    when 'canceled'
      redirect_to room_reservation_path(@reservation.room, @reservation), notice: 'Poxa, que pena que teve que cancelar. Conte com a gente na sua próxima viagem.'
    when 'active'
      @reservation.update(check_in: Time.zone.now)
      redirect_to room_reservation_path(@reservation.room, @reservation), notice: 'Check-in realizado.'
    when 'closing'
      PriceCalculator.new(@reservation).billing
      redirect_to room_reservation_path(@reservation.room, @reservation), notice: 'Preparando check-out'
    when 'closed'
      redirect_to room_reservation_path(@reservation.room, @reservation), notice: 'Check-out realizado.'
    when 'rated'
      @reservation.update(params.require(:reservation).permit(:grade, :comment))
      redirect_to room_reservation_path(@reservation.room, @reservation), notice: 'Sua avaliação foi recebida. Obrigado!'
    when 'answered'
      @reservation.update(params.require(:reservation).permit(:response))
      redirect_to room_reservation_path(@reservation.room, @reservation), notice: 'Sua resposta foi recebida. Obrigado!'
    end
  end

  def reservation_params
    params.require(:reservation)
          .permit(:start_date, :end_date, :guests, :room_id, :user_id)
  end

  def user_params
    params.require(:reservation)
          .permit(:user_id)
  end

  def rating_params
    params.require(:reservation)
          .permit(:grade, :comment, :response)
  end

  def update_params
    params.require(:reservation)
          .permit(:status, :payment)
  end
end
