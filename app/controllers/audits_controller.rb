class AuditsController < ApplicationController
  # GET /audits
  # GET /audits.json
  def index
    if params[:start_date] and params[:end_date]
      @start_date = parse_date params[:start_date]
      @end_date = parse_date params[:end_date]
    else
      # If no range is specified, show audits from the current year.
      @start_date = Date.new(Date.tomorrow.year)
      @end_date = Date.tomorrow
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

    respond_to do |format|
      format.html #index.html.haml
      format.json { render json: {
        :sum => params[:api] != 'v2' ? @sum / 100.0 : @sum ,
        :payments_sum => params[:api] != 'v2' ? @payments_sum / 100.0 : @payments_sum,
        :deposits_sum => params[:api] != 'v2' ? @deposits_sum / 100.0 : @deposits_sum,
        :audits => params[:api] != 'v2' ? @audits.map { |a| a.v1 } : @audits.map { |a| a.v2 }
      } }
    end
  end

  private

  def parse_date data
    return Date.civil(data[:year].to_i, data[:month].to_i, data[:day].to_i)
  end
end
