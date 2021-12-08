class Audit < ApplicationRecord
  validates :difference, presence: true
  belongs_to :drink, optional: true, foreign_key: :drink
  belongs_to :user, optional: true, foreign_key: :user
  default_scope ->{ order('created_at DESC') }

  scope :deposits, ->{ where('difference > 0') }
  scope :payments, ->{ where('difference < 0') }

  def as_json(options)
    h = super(options)
    h['drink'] = h['drink']['id'] if h['drink']
    h.delete('user')
   return h
  end
end
