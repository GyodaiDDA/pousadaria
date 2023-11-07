class Seasonal < ApplicationRecord
  belongs_to :room
  validates :start_date, :end_date, :special_price, :room_id, presence: true
  validates_with no_date_overlaping
  validates_with no_backward_dates
  validates_with no_bygone_dates
end
