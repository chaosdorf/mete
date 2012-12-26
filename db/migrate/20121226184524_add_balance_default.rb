class AddBalanceDefault < ActiveRecord::Migration
  def up
    change_column :users, :balance_cents, :integer, default: 0
  end

  def down
    change_column :users, :balance_cents, :integer, default: nil
  end
end
