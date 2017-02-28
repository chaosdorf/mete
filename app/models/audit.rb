class Audit < ActiveRecord::Base
  validates_presence_of :difference
  default_scope ->{ order('created_at DESC') }

  scope :deposits, ->{ where('difference > 0') }
  scope :payments, ->{ where('difference < 0') }

  def as_json(options)
    h = super(options)
    h.delete('user')
   return h
  end
end
