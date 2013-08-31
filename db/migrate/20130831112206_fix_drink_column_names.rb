class FixDrinkColumnNames < ActiveRecord::Migration
  def change
    change_table :drinks do |t|
      t.rename :bottleSize, :bottle_size
      t.rename :donationRecommendation, :donation_recommendation
      t.rename :logoUrl, :logo_url
    end
  end
end
