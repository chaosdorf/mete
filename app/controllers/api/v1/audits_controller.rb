class Api::V1::AuditsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  # GET /audits.json
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

    render json: {
        :sum => @sum,
        :payments_sum => @payments_sum,
        :deposits_sum => @deposits_sum,
        :audits => @audits
    }
  end

  private

  def parse_date data
    return Date.civil(data[:year].to_i, data[:month].to_i, data[:day].to_i)
  end
end
