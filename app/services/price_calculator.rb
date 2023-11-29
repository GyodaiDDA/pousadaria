class PriceCalculator
  attr_accessor :bill

  def initialize(reservation)
    @reservation = reservation
    @start_date = reservation.start_date.to_date
    @end_date = reservation.end_date.to_date
    @check_out_limit = @reservation.room.inn.check_out
    @bill = {}
  end

  def calculate
    prices = if @reservation.check_in.blank?
               count_days(@start_date, @end_date)
             else
               check_out = late_check_out? ? Time.zone.today : Time.zone.tomorrow
               count_days(@reservation.check_in.to_date, check_out)
             end

    prices.map do |_key, value|
      value[:nights] * value[:price]
    end.sum
  end

  def estimate
    @reservation.estimate = calculate
    @reservation.save
  end

  def billing
    return if @reservation.check_in.blank?

    @reservation.check_out = Time.zone.now
    @reservation.save
    @reservation.total_value = calculate
    @reservation.save
  end

  private

  def late_check_out?
    return unless @reservation.check_out

    expected_check_out_time = @check_out_limit.strftime('%H:%M')
    actual_check_out_time = @reservation.check_out.strftime('%H:%M')
    actual_check_out_time > expected_check_out_time
  end

  def relevant_promos(start_date, end_date)
    Seasonal.where(room_id: @reservation.room.id)
            .where('start_date <= ? AND end_date >= ?', end_date, start_date)
  end

  def count_days(start_date, end_date)
    prices = {}
    stay = (start_date..end_date).to_a
    regular_nights = stay.size

    relevant_promos(start_date, end_date).each do |promo|
      promo_nights = (stay & (promo.start_date..promo.end_date).to_a).count
      prices.store(promo.name, { nights: promo_nights, price: promo.special_price })
      regular_nights -= promo_nights
    end
    prices.store('Regular', { nights: regular_nights, price: @reservation.room.base_price })
    @bill = prices
    prices
  end
end
