class ChangeUserIdNullInReservations < ActiveRecord::Migration[7.1]
  def change
    change_column :reservations, :user_id, :integer, null: true
  end
end
