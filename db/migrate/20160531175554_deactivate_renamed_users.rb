class DeactivateRenamedUsers < ActiveRecord::Migration[4.2]
#via http://api.rubyonrails.org/classes/ActiveRecord/Migration.html
		def up
			User.all.each do |user|
				if user.name.start_with? "zz_"
					user.active = false
					user.name = user.name[3..-1]
					user.save!
				end
			end
		end

		def down
			User.where(active: false).all.each do |user|
				user.name = "zz_" + user.name
				user.active = true
				user.save!
			end
		end

	end
