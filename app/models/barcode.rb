class Barcode < ActiveRecord::Base

  validates_presence_of :drink, :value
  belongs_to :drink

end
