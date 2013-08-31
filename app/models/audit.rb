class Audit < ActiveRecord::Base
  default_scope ->{ order('created_at DESC') }
  
  scope :deposits, ->{ where('difference_cents > 0') }
  scope :payments, ->{ where('difference_cents < 0') }
  
  monetize :difference_cents
end
