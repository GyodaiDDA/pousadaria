class AddColumnsToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :check_in, :datetime
    add_column :reservations, :check_out, :datetime
    add_column :reservations, :payment, :string
  end
end
