class CancelationValidator < ActiveModel::Validator
  def validate(record)
    return if record.errors.present?

    cancelation_period(record)
  end

  def cancelation_period(record)
    return unless (record.start_date - Time.zone.today).to_i < 7

    record.errors.add(:base, 'O período de cancelamento de 7 dias já passou.')
  end
end
