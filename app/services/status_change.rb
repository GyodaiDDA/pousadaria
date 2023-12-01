class StatusChange
  def initialize; end

  def procedure(reservation, params)
    case reservation.status
    when 'active'
      reservation.update(check_in: Time.zone.now)
    when 'closing'
      PriceCalculator.new(reservation).billing
    when 'rated'
      Rails.logger.info "TRES! : #{params}"
      reservation.update(params.require(:reservation).permit(:grade, :comment, :status))
    when 'answered'
      reservation.update(params.require(:reservation).permit(:response))
    end
  end
end
