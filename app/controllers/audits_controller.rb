class AuditsController < ApplicationController
  def index
    @audits = Audit.all
    @sum = Audit.sum(&:difference)
    @payments_sum = Audit.payments.sum(&:difference).abs
    @deposits_sum = Audit.deposits.sum(&:difference)
  end
end
