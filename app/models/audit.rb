class Audit < ActiveRecord::Base
  attr_accessible :created_at, :difference, :difference_cents

  monetize :difference_cents
end
