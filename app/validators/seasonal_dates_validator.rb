class DatesValidator < ActiveModel::Validator
  def no_date_overlaping(start_date, end_date)
    if Seasonal.where(room_id:)
               .where.not(id:) # Excludes itself if the seasonal already exists
               .where('start_date < ? OR end_date > ?', end_date, start_date)
               .exists?
      record.errors.add(:base, 'Já existem períodos para esta data neste quarto.')
    end
  end

  def no_backward_dates(start_date, end_date)
    return false unless start_date > end_date

    record.errors.add(:base, 'A data final não pode ser menor que a data inicial.')
  end

  def no_bygone_dates(start_date, end_date)
    return false unless start_date >= Time.zone.today && end_date >= Time.zone.today

    record.errors.add(:base, 'As datas usadas já passaram.')
  end
end
