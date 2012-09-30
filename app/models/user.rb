class User < ActiveRecord::Base
  attr_accessible :balance_cents, :name, :email
  monetize :balance_cents
end
