class Inn < ApplicationRecord
  belongs_to :user
  has_many :rooms
  validates :brand_name, :legal_name, :vat_number, :postal_code, presence: true
  validates :vat_number, uniqueness: true, length: { is: 14 }
end
