class AddDocumentToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :document, :string
  end
end
