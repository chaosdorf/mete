class Drink < ActiveRecord::Base
  attr_accessible :bottleSize, :caffeine, :donationRecommendation, :logoUrl, :name
end
