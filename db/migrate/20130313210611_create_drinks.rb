class CreateDrinks < ActiveRecord::Migration[5.0]
  def change
    create_table :drinks do |t|
      t.string :name
      t.string :bottleSize
      t.string :caffeine
      t.decimal :donationRecommendation
      t.string :logoUrl
      t.timestamps null: true
    end
  end
end
