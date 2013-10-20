class BottleSizeAndCaffeineToInt < ActiveRecord::Migration
  def change
    change_column :drinks, :bottle_size, :integer
    change_column :drinks, :caffeine, :integer
  end
end
