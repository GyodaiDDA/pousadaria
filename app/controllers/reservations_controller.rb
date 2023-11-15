class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[show]
  before_action :set_room, only: %i[new create]

  def index; end
  def new; end
  def show; end
  def create; end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end

  def room_reservations
    Reservation.all.select(room_id: params[:room_id])
  end

  def reservation_params
    params.require(:seasonal)
          .permit(:id, :code, :start_date, :end_date, :guests, :value, :status, :available, :room_id, :user_id)
  end
end
