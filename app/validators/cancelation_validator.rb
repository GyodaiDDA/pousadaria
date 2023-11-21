class CancelationValidator < ActiveModel::Validator
  def validate(record)
    cancelation_period(record)
  end

  def cancelation_period(record)
    # return unless record.canceled?
    return unless (record.start_date - Time.zone.today).to_i < 7

    record.errors.add(:base, 'O período de cancelamento de 7 dias já passou.')
  end
end
