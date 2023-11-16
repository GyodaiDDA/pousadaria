class Room < ApplicationRecord
  belongs_to :inn
  has_many :seasonals, dependent: :restrict_with_error
  has_many :reservations, dependent: :restrict_with_error
  validates :name, :size, :max_guests, :base_price, presence: true
  validates :size, numericality: { only_integer: true, greater_than: 0 }, allow_nil: false
end
