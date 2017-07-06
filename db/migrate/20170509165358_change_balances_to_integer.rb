class ChangeBalancesToInteger < ActiveRecord::Migration[4.2]
  def up
    execute 'UPDATE users SET balance = balance * 100'
    execute 'UPDATE audits SET difference = difference * 100'
    execute 'UPDATE drinks SET price = price * 100'
    change_column :users, :balance, :integer, default: 0
    change_column :audits, :difference, :integer, default: 0
    change_column :drinks, :price, :integer, default: 150
  end

  def down
    change_column :users, :balance, :decimal, default: 0.0, precision: 20, scale: 2
    change_column :audits, :difference, :decimal, default: 0.0, precision: 20, scale: 2
    change_column :drinks, :price, :integer, default: 1.5, precision: 20, scale: 2
    execute 'UPDATE drinks SET price = price / 100'
    execute 'UPDATE users SET balance = balance / 100'
    execute 'UPDATE audits SET difference = difference / 100'
  end
end
