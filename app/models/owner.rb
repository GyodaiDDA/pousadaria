class Owner < User
  has_one :inn, dependent: :restrict_with_error
end
