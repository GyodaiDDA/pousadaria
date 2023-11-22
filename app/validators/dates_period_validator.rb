class DatesPeriodValidator < ActiveModel::Validator
  def validate(record)
    return if record.errors.present?

    no_backward_dates(record)
    no_bygone_dates(record)
  end

  def no_backward_dates(record)
    return if record.start_date.before?(record.end_date)

    record.errors.add(:base, 'A data final não pode ser menor que a data inicial.')
  end

  def no_bygone_dates(record)
    return if record.start_date.future?

    record.errors.add(:base, 'A data escolhida já passou.')
  end
end
