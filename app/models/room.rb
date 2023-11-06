class Room < ApplicationRecord
  belongs_to :inn
  validates :name, :size, :max_guests, :base_price, presence: true
end
