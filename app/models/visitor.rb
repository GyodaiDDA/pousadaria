class Visitor < ApplicationRecord
  belongs_to :reservation
  validates :full_name, :email, :document, presence: true
end
