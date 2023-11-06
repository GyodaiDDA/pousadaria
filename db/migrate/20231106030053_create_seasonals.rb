class CreateSeasonals < ActiveRecord::Migration[7.1]
  def change
    create_table :seasonals do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.float :special_price
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
