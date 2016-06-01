class AuditsController < ApplicationController
  # GET /audits
  # GET /audits.json
  def index
    if params[:start_date] and params[:end_date]
      @start_date = parse_date params[:start_date]
      @end_date = parse_date params[:end_date]
      @audits = Audit.where("created_at >= :start_date AND created_at <= :end_date", start_date: @start_date, end_date: @end_date)
    else
      @audits = Audit.all
    end

    @sum = @audits.sum(:difference)
    @payments_sum = @audits.payments.sum(:difference).abs
    @deposits_sum = @audits.deposits.sum(:difference)

    respond_to do |format|
      format.html #index.html.haml
      format.json { render json: {
        :sum => @sum,
        :payments_sum => @payments_sum,
        :deposits_sum => @deposits_sum,
        :audits => @audits
      }}
    end
  end

  private

  def parse_date data
    return Date.civil(data[:year].to_i, data[:month].to_i, data[:day].to_i)
  end
end
