class Drink < ActiveRecord::Base
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_presence_of :name, :bottle_size, :price
end
