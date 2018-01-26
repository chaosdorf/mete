class Api::V1::UsersController < ApplicationController
  
  # GET /users.json
  def index
    @users = User.order(active: :desc).order_by_name_asc
    render json: @users
  end

  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @drinks = Drink.order(active: :desc).order_by_name_asc
    render json: @user
  end

  # GET /users/new.json
  def new
    @user = User.new
    render json: @user
  end

  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH /users/1
  # PATCH /users/1.json
  def update
    @user = User.find(params[:id])
    @old_audit_status = @user.audit
    if @user.update_attributes(user_params)
      if @user.audit != @old_audit_status
        unless @user.audit
          @user_audits = Audit.where(:user => @user.id)
          @user_audits.each do |audit|
            audit.user = nil
            audit.save!
          end
        end
      end
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # GET /users/1/deposit.json?amount=100
  def deposit
    @user = User.find(params[:id])
    @user.deposit(BigDecimal.new(params[:amount]))
    head :no_content
  end

  # GET /users/1/buy.json?drink=5
  def buy
    @user = User.find(params[:id])
    @drink = Drink.find(params[:drink])
    buy_drink
  end
  
  # POST /users/1/buy_barcode.json
  def buy_barcode
    @user = User.find(params[:id])
    unless Barcode.where(id: params[:barcode]).exists?
      render json: @user.errors, status: :unprocessable_entity
    else
      @drink = Drink.find(Barcode.find(params[:barcode]).drink)
      buy_drink
    end
  end

  # GET /users/1/pay.json?amount=1.5
  def payment
    @user = User.find(params[:id])
    @user.payment(BigDecimal.new(params[:amount]))
    head :no_content
  end

  # GET /users/stats.json
  def stats
    @user_count = User.count
    @balance_sum = User.sum(:balance)
    render json: { user_count: @user_count, balance_sum: @balance_sum }
  end

  private
  
  def buy_drink
    unless @drink.active?
      @drink.active = true
      @drink.save!
    end
    @user.buy(@drink)
    head :no_content
  end

  def user_params
    params.require(:user).permit(:name, :email, :balance, :active, :audit, :redirect)
  end
end
