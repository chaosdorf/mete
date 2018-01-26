class User < ActiveRecord::Base
  validates_presence_of :name
  scope :order_by_name_asc, -> {
    order(arel_table['name'].lower.asc)
  }


  after_save do |user|
    Audit.create! difference: user.balance - user.balance_before_last_save, drink: @purchased_drink.nil? ? 0 : @purchased_drink.id, user: user.audit? ? user.id : nil
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

  def payment(amount)
    self.balance -= amount
    save!
  end
end
