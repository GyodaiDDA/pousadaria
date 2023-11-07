class RenameUserColumnType < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :user_type, :user_type
  end
end
