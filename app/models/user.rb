# frozen_string_literal: true
require 'uri'
require 'httparty'

class User < ApplicationRecord
  validates :name, presence: true

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
      if Rails.application.config.mastodon_token && Rails.application.config.mastodon_instance
        toot(drink)
      end
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
  
  def toot(drink)
    response = HTTParty.post(
      Rails.application.config.mastodon_instance + "/api/v1/statuses", 
      body: URI.encode_www_form({status: drink.name + '!'}),
      :headers => {"Authorization" => 'Bearer ' + Rails.application.config.mastodon_token}
    )
    case response.code
      when 200...204
        puts "All good!"
      when 300...600
        puts "Something went wrong! #{response.code}"
      end
    end
  end
end
