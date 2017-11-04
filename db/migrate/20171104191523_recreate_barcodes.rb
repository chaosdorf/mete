class RecreateBarcodes < ActiveRecord::Migration[5.1]
  def change
    remove_column :drinks, :barcode, :integer
    drop_table :barcodes, id: false do |t|
      t.string :id
      t.primary_key :id
    end
    create_table :barcodes do |t|
      t.string :value
      t.index :value
      t.references :drink
    end
  end
end
