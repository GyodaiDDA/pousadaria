class DatesOverlapValidator < ActiveModel::Validator
  def validate(record)
    no_date_overlaping(record)
  end

  def no_date_overlaping(record)
    return unless Seasonal.where(room_id: record.room_id)
                          .where('start_date <= ? AND end_date >= ?', record.end_date, record.start_date)
                          .exists?

    record.errors.add(:base, 'Já existem períodos para esta data neste quarto.')
  end
end
