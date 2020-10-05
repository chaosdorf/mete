class Barcode < ApplicationRecord
  validates :id, :drink, presence: true
end
