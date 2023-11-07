class AddTypeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :user_type, :string
  end
end
