class Api::V1::ReservationsController < ActionController::API
  def create
    reservation_params = params.require(:reservation).permit(:room_id, :guests, :start_date, :end_date)
    reservation = Reservation.new(reservation_params)
    if reservation.save
      if reservation.status == 'available'
        render json: reservation.as_json(only: %i[code estimate]), status: :created
      elsif reservation.status == 'unavailable'
        render json: 'Não há disponibilidade para a reserva', status: :accepted
      end
    else
      render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
