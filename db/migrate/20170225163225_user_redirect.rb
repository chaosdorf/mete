class UserRedirect < ActiveRecord::Migration
#via http://api.rubyonrails.org/classes/ActiveRecord/Migration.html
	def up
		add_column :users, :redirect, :boolean, default: true
		User.all.each { |user| user.redirect = true }
	end

	def down
		remove_column :users, :redirect
	end
end
