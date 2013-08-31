class Audit < ActiveRecord::Base
  default_scope ->{ order('created_at DESC') }
  
  scope :deposits, ->{ where('difference > 0') }
  scope :payments, ->{ where('difference < 0') }
end
