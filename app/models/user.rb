class User < ActiveRecord::Base
  attr_accessible :name, :email, :balance
  monetize :balance_cents
  default_scope order('LOWER(name)')

  def deposit(amount)
    self.balance_cents += amount
    save!
  end
  def payment(amount)
    self.balance_cents -= amount
    save!
  end

  def self.balance_sum
    self.sum(:balance_cents) / 100.0
  end
end
