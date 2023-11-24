# app/services/price_calculator.rb
class PriceCalculator
  def initialize(reservation, special_price = nil)
    @reservation = reservation
    @price = special_price
    @price = @reservation.room.base_price if special_price.nil?
  end

  def estimate
    return unless @reservation.start_date && @reservation.end_date

    nights = (@reservation.end_date - @reservation.start_date).nonzero? || 1
    @reservation.estimate = nights * @price
    @reservation.save
  end

  def billing
    return if @reservation.check_in.blank?

    @reservation.check_out = Time.zone.now
    @reservation.nights = (@reservation.check_out.to_date - @reservation.check_in.to_date).nonzero? || 1
    @reservation.nights += 1 if late_check_out?
    @reservation.total_value = @reservation.nights * @price
    @reservation.save
  end

  def late_check_out?
    expected_check_out_time = @reservation.room.inn.check_out.strftime('%H:%M')
    actual_check_out_time = @reservation.check_out.strftime('%H:%M')
    Rails.logger.debug { "late_check_out? #{actual_check_out_time > expected_check_out_time}" }
    actual_check_out_time > expected_check_out_time
  end
end
