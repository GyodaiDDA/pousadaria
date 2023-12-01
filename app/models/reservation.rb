class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user, optional: true
  has_many :visitors, dependent: :restrict_with_error
  validates :room_id, :start_date, :end_date, :guests, presence: true
  validates :guests, numericality: { only_integer: true, greater_than: 0 }, allow_nil: false
  validate :guest_count
  validates_with PeriodValidator, if: -> { new_record? }
  before_create :generate_code
  before_create :initial_status

  enum status: { unavailable: 0, available: 1, expired: 2, confirmed: 3, canceled: 4, registered: 5, active: 6, closing: 7, closed: 8, rated: 9, answered: 10 }

  scope :active, -> { where(status: 'active') }

  def initial_status
    self.status = (OverlapChecker.overlap?(self) ? 'unavailable' : 'available')
  end

  def self.l_enum(status)
    I18n.t("activerecord.enums.reservation.status.#{status}")
  end

  def check_expiration
    return unless status == 'available' && start_date < Time.zone.tomorrow

    self.status = 'expired'
    save
  end

  private

  def guest_count
    return if room.nil?
    return if guests.nil?
    return unless guests > room.max_guests

    errors.add(:base, "O número de hóspedes está acima da capacidade do quarto (#{room.max_guests}).")
  end

  def generate_code
    try_code = SecureRandom.alphanumeric(8).upcase
    loop do
      break unless Reservation.where(code: try_code).exists?

      try_code = SecureRandom.alphanumeric(8).upcase
    end
    self.code = try_code
  end
end
