class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user, optional: true
  validates :room_id, :start_date, :end_date, :guests, presence: true
  validate :guest_count
  validates_with DatesPeriodValidator
  # validates_with CancelationValidator, on: :cancelation

  before_create :generate_code

  enum status: { unavailable: 0, available: 1, confirmed: 3, canceled: 4, checked_in: 5, checked_out: 7 }

  def self.available?(params)
    return 'unavailable' if Reservation.where(room_id: params[:room_id])
                           .where.not(id: nil)
                           .where('start_date <= ? AND end_date >= ?', params[:end_date], params[:start_date])
                           .exists?

    'available'
  end

  private

  def generate_code
    try_code = SecureRandom.alphanumeric(8).upcase
    loop do
      break unless Reservation.where(code: try_code).exists?

      try_code = SecureRandom.alphanumeric(8).upcase
    end
    self.code = try_code
  end

  def guest_count
    return if room.nil?
    return unless guests > room.max_guests

    error.add(:base, "O número de hóspedes está acima da capacidade do quarto (#{room.max_guests}).")
  end
end
