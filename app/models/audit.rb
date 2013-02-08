class Audit < ActiveRecord::Base
  default_scope ->{ order('created_at DESC') }
  
  attr_accessible :created_at, :difference, :difference_cents

  monetize :difference_cents
end
