class Seasonal < ApplicationRecord
  belongs_to :room
  validates :start_date, :end_date, :special_price, presence: true
  validate :no_date_overlap
  validates_with DatesPeriodValidator

  def no_date_overlap
    return unless DatesChecker.overlap?(self)

    errors.add(:base, 'Já existem períodos para esta data neste quarto.')
  end
end
