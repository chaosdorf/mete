class Audit < ActiveRecord::Base
  default_scope ->{ order('created_at DESC') }
  
  scope :deposits, ->{ where('difference_cents > 0') }
  scope :payments, ->{ where('difference_cents < 0') }
  
  attr_accessible :created_at, :difference, :difference_cents

  monetize :difference_cents
end
