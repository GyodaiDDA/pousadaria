class DatesValidator < ActiveModel::Validator
  def validate(record)
    no_date_overlaping(record)
    no_backward_dates(record)
    no_bygone_dates(record)
  end

  def no_date_overlaping(record)
    return unless Seasonal.where(room_id: record.room_id)
                          .where.not(id: record.id)
                          .where('start_date < ? OR end_date > ?', record.end_date, record.start_date)
                          .exists?

    record.errors.add(:base, 'Já existem períodos para esta data neste quarto.')
  end

  def no_backward_dates(record)
    return if record.start_date < record.end_date

    record.errors.add(:base, 'A data final não pode ser menor que a data inicial.')
  end

  def no_bygone_dates(record)
    return if record.start_date >= Time.zone.today && record.end_date >= Time.zone.today

    record.errors.add(:base, 'As datas escolhidas já passaram.')
  end
end
