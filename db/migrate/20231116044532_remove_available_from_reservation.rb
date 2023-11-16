class RemoveAvailableFromReservation < ActiveRecord::Migration[7.1]
  def change
    remove_column :reservations, :available, :boolean
  end
end
