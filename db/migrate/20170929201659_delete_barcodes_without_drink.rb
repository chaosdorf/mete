class DeleteBarcodesWithoutDrink < ActiveRecord::Migration[5.0]
  def up
    Barcode.all.each do |barcode|
      unless Drink.find_by(:id => barcode.drink)
        puts "Deleting barcode #{barcode.id}, because the associated drink doesn't exist."
        barcode.destroy!
      end
    end
  end
  
  def down
    puts "Deleted barcodes can't be restored."
  end
end
