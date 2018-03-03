class UsersController < ApplicationController
  include ApplicationHelper

  # GET /users
  def index
    @users = User.order(active: :desc).order_by_name_asc
    # index.html.haml
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @drinks = Drink.order(active: :desc).order_by_name_asc
    # show.html.haml
  end

  # GET /users/new
  def new
    @user = User.new
    # new.html.haml
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    # edit.html.haml
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, success: 'User was successfully created.'
    else
      render action: "new", error: "Couldn't create the user. Error: #{@user.errors} Status: #{:unprocessable_entity}"
    end
  end

  # PATCH /users/1
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
          flash[:notice] = "Deleted all your logs."
        end
      end
      flash[:success] = "User was successfully updated."
      no_resp_redir @user
    else
      render action: "edit", error: "Couldn't update the user. Error: #{@user.errors} Status: #{:unprocessable_entity}"
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "User was successfully deleted."
      no_resp_redir users_url
    else
      redirect_to users_url, error:  "Couldn't delete the user. Error: #{@user.errors} Status: #{:unprocessable_entity}"
    end
  end

  # GET /users/1/deposit?amount=100
  def deposit
    @user = User.find(params[:id])
    @user.deposit(BigDecimal.new(params[:amount]))
    flash[:success] = "You just deposited some money and your new balance is #{show_amount(@user.balance)}. Thank you."
    warn_user_if_audit
    no_resp_redir @user
  end

  # GET /users/1/buy?drink=5
  def buy
    @user = User.find(params[:id])
    @drink = Drink.find(params[:drink])
    buy_drink
  end

  # POST /users/1/buy_barcode
  def buy_barcode
    @user = User.find(params[:id])
    unless Barcode.where(id: params[:barcode]).exists?
      flash[:danger] = "No drink found with this barcode."
      redirect_to @user
    else
      @drink = Drink.find(Barcode.find(params[:barcode]).drink)
      buy_drink
    end
  end

  # GET /users/1/pay?amount=1.5
  def payment
    @user = User.find(params[:id])
    @user.payment(BigDecimal.new(params[:amount]))
    flash[:success] = "You just bought a drink and your new balance is #{show_amount(@user.balance)}. Thank you."
    if (@user.balance < 0) then
      flash[:warning] = "Your balance is below zero. Remember to compensate as soon as possible."
    end
    warn_user_if_audit
    no_resp_redir @user
  end

  # GET /users/stats
  def stats
    @user_count = User.count
    @balance_sum = User.sum(:balance)
    # stats.html.haml
  end

  private

  def buy_drink
    unless @drink.active?
      @drink.active = true
      @drink.save!
      flash[:info] = "The drink you just bought has been set to 'available'."
    end
    @user.buy(@drink)
    flash[:success] = "You just bought a drink and your new balance is #{show_amount(@user.balance)}. Thank you."
    if (@user.balance < 0) then
      flash[:warning] = "Your balance is below zero. Remember to compensate as soon as possible."
    end
    warn_user_if_audit
    no_resp_redir @user.redirect ? users_url + '/#' + @user.initial : @user
  end

  def user_params
    params.require(:user).permit(:name, :email, :balance, :active, :audit, :redirect)
  end

  def warn_user_if_audit
    if (@user.audit) then
      flash[:info] = "This transaction has been logged, because you set up your account that way. #{view_context.link_to 'Change?', edit_user_url(@user)}".html_safe
    end
  end
end
