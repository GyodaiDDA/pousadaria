class CreateInns < ActiveRecord::Migration[7.1]
  def change
    create_table :inns do |t|
      t.string :brand_name
      t.string :legal_name
      t.string :vat_number
      t.text :phone
      t.string :email
      t.string :address
      t.string :zone
      t.string :city
      t.string :state
      t.string :postal_code
      t.text :description
      t.text :payment_options
      t.boolean :pet_friendly
      t.boolean :wheelchair_accessible
      t.text :rules
      t.time :check_in
      t.time :check_out
      t.boolean :active
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
