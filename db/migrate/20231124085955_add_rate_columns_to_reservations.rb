class AddRateColumnsToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :grade, :integer
    add_column :reservations, :comment, :string
    add_column :reservations, :response, :string
  end
end
