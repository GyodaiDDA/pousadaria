class Seasonal < ApplicationRecord
  belongs_to :room
  validates :start_date, :end_date, :special_price, presence: true
  validates_with DatesValidator
end
