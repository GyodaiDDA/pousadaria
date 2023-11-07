class User < ApplicationRecord
  has_one :inn, dependent: :restrict_with_error
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
