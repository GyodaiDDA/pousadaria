class RemoveColumnPaymentOptionsFromInns < ActiveRecord::Migration[7.1]
  def change
    remove_column :inns, :payment_options
  end
end
