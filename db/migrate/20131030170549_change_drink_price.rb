class ChangeDrinkPrice < ActiveRecord::Migration[4.2]
  def change
    change_column :drinks, :price, :decimal, precision: 20, scale: 2, default: 0.0
  end
end
