class Inn < ApplicationRecord
  belongs_to :user
  has_many :rooms, dependent: :restrict_with_error
  validates :brand_name, :legal_name, :vat_number, :city, :state, :postal_code, presence: true
  validates_with CnpjValidator
end
