# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true

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

  def initial
    first = name[0, 1].downcase
    return first if first =~ /[a-z]/
    '0'
  end
end
