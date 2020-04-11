class AddCanOverdrawToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :can_overdraw, :boolean, default: true
    User.all.each { |user| user.can_overdraw = true }
  end
  
  def down
    remove_column :users, :can_overdraw
  end
end
