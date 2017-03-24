class Barcode < ActiveRecord::Base
  validates_presence_of :id, :drink
end