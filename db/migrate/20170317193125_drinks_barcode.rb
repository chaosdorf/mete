class DrinksBarcode < ActiveRecord::Migration[5.0]
	#via http://api.rubyonrails.org/classes/ActiveRecord/Migration.html
	def up
		add_column :drinks, :barcode, :string
		add_index :drinks, :barcode
	end
	
	def down
		remove_index :drinks, column: :barcode
		remove_column :drinks, :barcode
	end
end