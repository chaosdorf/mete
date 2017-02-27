class NormalizeColumnNames < ActiveRecord::Migration[4.2]
  def change
    change_table :drinks do |t|
      t.rename :bottleSize, :bottle_size
      t.rename :donationRecommendation, :price
      t.rename :logoUrl, :logo_file_name
    end
  end
end
