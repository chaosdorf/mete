class CreateBarcodes < ActiveRecord::Migration[5.0]
  def up
    create_table :barcodes, id: :string do |t|
      t.integer :drink, null: false
    end
    puts "Migrating existing barcodes…"
    Drink.all.each do |drink|
      unless drink.barcode.nil?
        unless drink.barcode.empty?
          puts "Processing #{drink.barcode} -> #{drink.name}…"
          barcode = Barcode.new(:id => drink.barcode, :drink => drink.id)
          barcode.save!
        end
      end
    end
    remove_index :drinks, column: :barcode
    remove_column :drinks, :barcode
  end
  
  def down
    add_column :drinks, :barcode, :string
    add_index :drinks, :barcode
    Drink.reset_column_information
    puts "Migrating existing barcodes…"
    Barcode.all.each do |barcode|
      drink = Drink.find(barcode.drink)
      puts "Processing #{barcode.id} -> #{drink.name}…"
      drink.barcode = barcode.id
      drink.save!
    end
    drop_table :barcodes
  end
end
