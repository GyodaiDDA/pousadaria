class CreateVisitors < ActiveRecord::Migration[7.1]
  def change
    create_table :visitors do |t|
      t.string :full_name
      t.string :email
      t.string :document
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
