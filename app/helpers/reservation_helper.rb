module ReservationHelper
  def reservation_management(reservation)
    case reservation.status
    when 'confirmed'
      confirmed_menu(reservation)
    when 'registered'
      registered_menu(reservation)
    when 'active'
      active_menu(reservation)
    when 'closing'
      checking_out_menu(reservation)
    when 'rated'
      rated_menu(reservation)
    end
  end

  def reservation_dashboard(reservation)
    case reservation.status
    when 'closed'
      closed_menu(reservation)
    end
  end

  private

  def confirmed_menu(reservation)
    forms = reservation.guests.to_i - reservation.visitors.size
    if forms > 0
      forms.times do 
        concat render(partial: 'visitors/new', locals: { reservation_id: reservation.id, visitor: @visitor = Visitor.new })
      end
      ''
    end
  end

  def registered_menu(reservation)
    render(partial: 'reservations/status_progression', locals: { reservation: reservation, room: reservation.room, button_tag: 'Fazer check-in', status: 'active' })
  end

  def active_menu(reservation)
    render(partial: 'reservations/status_progression', locals: { reservation: reservation, room: reservation.room, button_tag: 'Iniciar check-out', status: 'closing' })
  end

  def checking_out_menu(reservation)
    render(partial: 'reservations/status_progression', locals: { reservation: reservation, room: reservation.room, button_tag: 'Finalizar', status: 'closed' })
  end

  def closed_menu(reservation)
    render(partial: 'reservations/status_progression', locals: { reservation: reservation, room: reservation.room, button_tag: 'Avaliar', status: 'rated' })
  end

  def rated_menu(reservation)
    render(partial: 'reservations/status_progression', locals: { reservation: reservation, room: reservation.room, button_tag: 'Responder', status: 'answered' })
  end
end
