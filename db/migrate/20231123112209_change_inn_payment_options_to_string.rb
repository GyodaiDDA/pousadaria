class ChangeInnPaymentOptionsToString < ActiveRecord::Migration[7.1]
  def change
    change_column :inns, :payment_options, :string
  end
end
