class Audit < ActiveRecord::Base
  validates_presence_of :difference
  default_scope -> { order('created_at DESC') }

  scope :deposits, -> { where('difference > 0') }
  scope :payments, -> { where('difference < 0') }

  def as_json(options = nil)
    h = super(options)
    h.delete('user')
    h
  end

  def v1
    h = as_json
    h['difference'] /= 100.0
    h
  end

  def v2
    h = as_json
    h['product'] = h['drink']
    h.delete('drink')
    h
  end

end
