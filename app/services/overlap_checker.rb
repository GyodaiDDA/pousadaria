class OverlapChecker
  def self.overlap?(record)
    return unless record.start_date && record.end_date && record.room_id

    if record.instance_of?(Seasonal)
      record.class
            .where(room_id: record.room_id)
            .where.not(id: record.id)
            .where('start_date <= ? AND end_date >= ?', record.end_date, record.start_date)
            .exists?
    elsif record.instance_of?(Reservation)
      record.class
            .where(room_id: record.room_id)
            .where.not(id: record.id)
            .where('status IS NOT ? AND start_date <= ? AND end_date >= ?', 0, record.end_date, record.start_date)
            .exists?
    end
  end
end
