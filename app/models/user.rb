class User < ActiveRecord::Base
  default_scope ->{order('LOWER(name)')}
  validates_presence_of :name


  after_save do |user|
    Audit.create! difference: user.balance - user.balance_was, drink: @purchased_drink.nil? ? 0 : @purchased_drink.id
  end

  def self.balance_sum
    self.sum(:balance)
  end

  def deposit(amount)
    self.balance += amount
    save!
  end

  def buy(drink)
    self.balance -= drink.price
    @purchased_drink = drink
    save!
  end
end
