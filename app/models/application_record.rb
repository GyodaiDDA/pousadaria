class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  self.abstract_class = true
  self.inheritance_column = 'user_type'
end
