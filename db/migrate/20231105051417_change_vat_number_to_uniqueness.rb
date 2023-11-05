class ChangeVatNumberToUniqueness < ActiveRecord::Migration[7.1]
  def change
    add_index :inns, :vat_number, unique: true
  end
end
