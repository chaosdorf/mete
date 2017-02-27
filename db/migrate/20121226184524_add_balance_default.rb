class AddBalanceDefault < ActiveRecord::Migration[4.2]
  def up
    change_column :users, :balance_cents, :integer, default: 0
  end

  def down
    change_column :users, :balance_cents, :integer, default: nil
  end
end
