class RenameColumnValueInReservations < ActiveRecord::Migration[7.1]
  def change
    rename_column :reservations, :value, :total_value
  end
end
