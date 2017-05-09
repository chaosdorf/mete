class Audit < ActiveRecord::Base
  validates_presence_of :difference
  default_scope -> { order('created_at DESC') }

  scope :deposits, -> { where('difference > 0') }
  scope :payments, -> { where('difference < 0') }

  def as_json(options)
    h = super(options)
    h.delete('user')
    return h
  end

  def v2(options)
    h = as_json(options)
    h['product'] = h['drink']
    h.delete('drink')
    return h
  end

end
