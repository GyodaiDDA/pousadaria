class Seasonal < ApplicationRecord
  belongs_to :room
  validates :start_date, :end_date, :special_price, :room_id, presence: true
  validate :no_date_overlap

  private

  def no_date_overlap
    # Check if there's any other seasonal for the same room with overlapping dates
    if Seasonal.where(room_id: room_id)
               .where.not(id: id) # Excludes itself if the seasonal already exists
               .where('start_date < ? AND end_date > ?', end_date, start_date)
               .exists?
      errors.add(:base, 'There is already a seasonal booked for these dates.')
    end
  end
end
