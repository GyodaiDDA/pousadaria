class ChangeInnPaymentOptionsType < ActiveRecord::Migration[7.1]
  def change
    change_column :inns, :payment_options, :integer
  end
end
