# app/services/price_calculator.rb
class PriceCalculator
  def initialize(reservation)
    @reservation = reservation
  end

  def call
    return unless @reservation.start_date && @reservation.end_date && @reservation.room.base_price

    period = (@reservation.end_date - @reservation.start_date).to_i
    @reservation.total_value = period * @reservation.room.base_price
  end
end
