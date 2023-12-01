class Inn < ApplicationRecord
  belongs_to :user
  has_many :rooms, dependent: :restrict_with_error
  has_many :reservations, through: :rooms
  validates :brand_name, :legal_name, :vat_number, :city, :state, :postal_code, presence: true
  validates_with CnpjValidator
  validate :user_is_owner

  def user_is_owner
    @user = User.find_by(id: user_id)
    return if @user.user_type == 'Owner'

    errors.add(:base, 'O cadastro de usuário não é proprietário')
  end

  def ratings
    reservations.select(:grade, :comment, :user_id, :response)
                .where.not(grade: nil)
                .order(:created_at).reverse
  end

  def avg_rating
    reservations.average(:grade).to_i
  end

  def self.by_cities
    Inn.where(active: true)
       .order(:city)
       .order(:brand_name)
       .group_by(&:city)
  end

  def self.by_location(params)
    city = params['city']
    state = params['state']
    @inns = Inn.where(active: true)
    @inns = @inns.where('city LIKE ?', "%#{city}") if city.present?
    @inns = @inns.where('state LIKE ?', "%#{state}") if state.present?
    @inns.order(:state).order(:city)
  end
end
