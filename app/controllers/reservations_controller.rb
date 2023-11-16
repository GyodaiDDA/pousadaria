class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[show]
  before_action :set_room, only: %i[index new]

  def index
    room_reservations
    set_room_user_reservations
  end

  def new
    @reservation = Reservation.new
  end

  def show; end

  def create
    @reservation = Reservation.new(consultation_params)
    @reservation.status = Reservation.available?(consultation_params)

    if @reservation.save
      if @reservation.status == 'available'
        redirect_to room_reservation_path(@reservation.room, @reservation), notice: 'Legal! Quarto disponível para esta reserva.'
      else
        redirect_to room_path(@reservation.room_id), notice: 'Que pena! Quarto indisponível para esta reserva.'
      end
    else
      flash[:alert] = 'Ocorreu um problema no processamento da sua consulta.'
      render 'new'
    end
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
    @room = @reservation.room
  end

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end

  def consultation_params
    params.require(:reservation)
          .permit(:start_date, :end_date, :guests, :room_id)
  end

  def confirmation_params
    params.require(:reservation)
          .permit(:code, :guests, :value, :user_id)
  end
end
