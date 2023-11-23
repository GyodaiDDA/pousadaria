class Inn < ApplicationRecord
  belongs_to :user
  has_many :rooms, dependent: :restrict_with_error
  validates :brand_name, :legal_name, :vat_number, :city, :state, :postal_code, presence: true
  validates_with CnpjValidator

  enum payment_options: { debit_card: 1, credit_card: 2, pix: 3, gpay: 4, apay: 5, cash: 6 }
end
