class AuditsController < ApplicationController
  # GET /audits
  def index
    if params[:start_date] and params[:end_date]
      @start_date = parse_date params[:start_date]
      @end_date = parse_date params[:end_date]
    else
      # If no range is specified, show audits from the last 14 days.
      @start_date = Date.today - 14
      @end_date  = Date.tomorrow
    end
    if params[:user]
      @user = User.find(params[:user])
      @audits = Audit.where(user: @user).where(created_at: (@start_date..@end_date))
    else
      @audits = Audit.where(created_at: (@start_date..@end_date))
      @user = nil
    end

    @sum = @audits.sum(:difference)
    @payments_sum = @audits.payments.sum(:difference).abs
    @deposits_sum = @audits.deposits.sum(:difference)
    # index.html.haml
  end

  private

  def parse_date data
    return Date.civil(data[:year].to_i, data[:month].to_i, data[:day].to_i)
  end
end
