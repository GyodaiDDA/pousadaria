class AddColumnPaymentOptToInns < ActiveRecord::Migration[7.1]
  def change
    add_column :inns, :payment_opt, :string
  end
end
