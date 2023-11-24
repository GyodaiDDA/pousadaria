class AddColumnDaysToReservation < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :nights, :integer
  end
end
