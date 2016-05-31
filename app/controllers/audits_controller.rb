class AuditsController < ApplicationController
  # GET /audits
  # GET /audits.json
  def index
    if params[:start_date] and params[:end_date]
      @start_date = Date.civil(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
      @end_date = Date.civil(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)
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
end
