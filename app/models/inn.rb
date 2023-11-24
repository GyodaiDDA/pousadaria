class Inn < ApplicationRecord
  belongs_to :user
  has_many :rooms, dependent: :restrict_with_error
  has_many :reservations, through: :rooms
  validates :brand_name, :legal_name, :vat_number, :city, :state, :postal_code, presence: true
  validates_with CnpjValidator

  def ratings
    reservations.select(:grade, :comment, :user_id, :response)
                .where.not(grade: nil)
                .order(:created_at).reverse
  end

  def avg_rating
    reservations.average(:grade)
  end

  def self.by_city
    Inn.where(active: true)
       .order(:city)
       .order(:brand_name)
       .group_by(&:city)
  end
end
