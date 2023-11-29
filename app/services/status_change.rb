class StatusChange
  def initialize; end

  def procedure(reservation, params)
    case reservation.status
    when 'active'
      reservation.update(check_in: Time.zone.now)
    when 'closing'
      PriceCalculator.new(reservation).billing
    when 'rated'
      reservation.update(params.require(:reservation).permit(:grade, :comment))
    when 'answered'
      reservation.update(params.require(:reservation).permit(:response))
    end
  end
end
