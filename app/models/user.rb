# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true

  enum :avatar_provider, [ :gravatar, :webfinger ]

  scope :order_by_name_asc, -> {
    order(arel_table['name'].lower.asc)
  }

  after_save do |user|
    Audit.create! difference: user.balance - user.balance_before_last_save, drink: @purchased_drink, user: user.audit? ? user : nil
  end

  def deposit(amount)
    with_lock do
      self.balance += amount
      save!
    end
  end

  def buy(drink)
    with_lock do
      self.balance -= drink.price
      @purchased_drink = drink
      save!
    end
  end

  def payment(amount)
    with_lock do
      self.balance -= amount
      save!
    end
  end

  def initial
    first = name[0, 1].downcase
    return first if first =~ /[a-z]/
    '0'
  end

  def email
    case avatar_provider
    when 'gravatar'
      avatar
    when 'webfinger'
      ''
    end
  end

  def as_json(options={})
    super(except: [ :avatar_provider, :avatar ], methods: :email)
  end
end
