class ActivateAllDrinks < ActiveRecord::Migration[4.2]
#via http://api.rubyonrails.org/classes/ActiveRecord/Migration.html
	def up
		add_column :drinks, :active, :boolean, default: true
		Drink.all.each { |drink| drink.active = true }
	end

	def down
		remove_column :drinks, :active
	end

end
