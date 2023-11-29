class ReservationsSelector
  def initialize(params = nil)
    @user = params[:user]
    @room = params[:room]
    @inn = params[:inn]
    @status = params[:status]
  end

  def find
    if @status
      find_with_status
    else
      find_all_status
    end
  end

  def find_all_status
    reservations = if @user
                     Reservation.where(user_id: @user.id)
                   elsif @room
                     Reservation.where(room_id: @room.id)
                   elsif @inn
                     Reservation.where(room_id: @inn.rooms)
                   else
                     Reservation.all
                   end
    expired?(reservations)
    reservations
  end

  def find_with_status
    return unless @status

    reservations = if @user
                     Reservation.where(user_id: @user.id, status: @status)
                   elsif @room
                     Reservation.where(room_id: @room.id, status: @status)
                   elsif @inn
                     Reservation.where(room_id: @inn.rooms, status: @status)
                   else
                     Reservation.where(status: @status)
                   end
    expired?(reservations)
    reservations
  end

  def expired?(reservations)
    reservations.each(&:check_expiration)
  end
end
