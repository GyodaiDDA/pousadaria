class AddColumnsToInn < ActiveRecord::Migration[7.1]
  def change
    add_column :inns, :legal_name, :string
    add_column :inns, :tax_number, :string
    add_column :inns, :phone, :string
    add_column :inns, :email, :string
    add_column :inns, :payment_options, :text
    add_column :inns, :pet_friendly, :boolean
    add_column :inns, :rules, :text
    add_column :inns, :active, :boolean
  end
end
