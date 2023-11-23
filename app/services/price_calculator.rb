# app/services/price_calculator.rb
class PriceCalculator
  def initialize(reservation, price = reservation.room.base_price)
    @reservation = reservation
    @price = price
  end

  def estimate
    return unless @reservation.start_date && @reservation.end_date

    period = (@reservation.end_date - @reservation.start_date).to_i
    @reservation.estimate = period * @price
  end

  def billing
    return if @reservation.check_in.blank?

    check_out_day

    period = ((@reservation.check_out - @reservation.check_in) / (60 * 60 * 24)).to_i
    @reservation.total_value = period * @price
  end

  def check_out_day
    expected_check_out = @reservation.room.inn.check_out.strftime('%H:%M')
    actual_check_out = Time.zone.now.strftime('%H:%M')
    @reservation.check_out = if actual_check_out > expected_check_out
                               Time.zone.tomorrow
                             else
                               Time.zone.today
                             end
  end
end
