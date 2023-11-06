class Seasonal < ApplicationRecord
  belongs_to :room
  validates :start_date, :end_date, :special_price, :room_id, presence: true
end
