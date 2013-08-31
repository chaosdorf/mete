class ChangeBalancesToDecimal < ActiveRecord::Migration
  def up
    add_column :users, :balance, :decimal, default: 0.0, precision: 20, scale: 2
    add_column :audits, :difference, :decimal, default: 0.0, precision: 20, scale: 2
    execute 'UPDATE users SET balance = balance_cents / 100'
    execute 'UPDATE audits SET difference = difference_cents / 100'
    remove_column :users, :balance_cents
    remove_column :audits, :difference_cents
  end
  
  def down
    add_column :users, :balance_cents, :integer, default: 0
    add_column :audits, :difference_cents, :integer, default: 0
    execute 'UPDATE users SET balance_cents = balance * 100'
    execute 'UPDATE audits SET difference_cents = difference * 100'
    remove_column :users, :balance
    remove_column :audits, :difference
  end
end
