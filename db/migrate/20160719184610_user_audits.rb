class UserAudits < ActiveRecord::Migration
#via http://api.rubyonrails.org/classes/ActiveRecord/Migration.html
	def up
		add_column :audits, :user, :int
		add_column :users, :audit, :boolean, default: false
	end

	def down
		remove_column :audits, :user
		remove_column :users, :audit
	end
end
