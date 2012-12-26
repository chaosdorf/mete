class User < ActiveRecord::Base
  attr_accessible :name, :email, :balance
  monetize :balance_cents
  default_scope order('name')

  def deposit(amount)
    self.balance_cents += amount
    save
  end
  def payment(amount)
    self.balance_cents -= amount
    save
  end
end
