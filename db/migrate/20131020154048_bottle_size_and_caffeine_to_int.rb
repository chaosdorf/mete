class BottleSizeAndCaffeineToInt < ActiveRecord::Migration[4.2]
  def change
    change_column :drinks, :bottle_size, :integer, using: 'bottle_size::integer'
    change_column :drinks, :caffeine, :integer, using: 'caffeine::integer'
  end
end
