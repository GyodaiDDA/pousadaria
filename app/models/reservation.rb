class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user
  validates :room_id, :start_date, :end_date, :guests, :available, presence: true
end
