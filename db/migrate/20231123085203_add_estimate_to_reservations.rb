class AddEstimateToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :estimate, :integer
  end
end
