class AddBarcodeToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :barcode, :string, null: true
    add_index :users, :barcode, unique: true, null: true
  end
end
