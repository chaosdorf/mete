class ActivateAllUsers < ActiveRecord::Migration[4.2]
#via http://api.rubyonrails.org/classes/ActiveRecord/Migration.html
		def up
			add_column :users, :active, :boolean, default: true
			User.all.each { |user| user.active = true }
		end

		def down
			remove_column :users, :active
		end

	end
