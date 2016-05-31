class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @drinks = Drink.order(active: :desc, name: :asc).all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, success: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /users/1
  # PATCH /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.destroy
        format.html { redirect }
        format.json { head :no_content }
      else
        format.html { redirect }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def deposit
    @user = User.find(params[:id])
    @user.deposit(BigDecimal.new(params[:amount]))
    respond_to do |format|
      format.html do
        flash[:success] = "You just deposited some money and your new balance is #{@user.balance}. Thank you."
        redirect(@user)
      end
      format.json { head :no-content }
    end
  end

  def buy
    @user = User.find(params[:id])
    @drink = Drink.find(params[:drink])
    unless @drink.active?
      @drink.active = true
      @drink.save!
      flash[:info] = "The drink you just bought has been set to 'available'."
    end
    @user.buy(@drink)
    respond_to do |format|
      format.html do
        flash[:success] = "You just bought a drink and your new balance is #{@user.balance}. Thank you."
        if (@user.balance < 0) then
          flash[:warning] = "Your balance is below zero. Remember to compensate as soon as possible."
        end
        redirect_to users_url
      end
    end
  end

  def payment
    @user = User.find(params[:id])
    @user.payment(BigDecimal.new(params[:amount]))
    respond_to do |format|
      format.html do
        flash[:success] = "You just bought a drink and your new balance is #{@user.balance}. Thank you."
        if (@user.balance < 0) then
          flash[:warning] = "Your balance is below zero. Remember to compensate as soon as possible."
        end
        redirect(@user)
      end
    end
  end

  def stats
    @user_count = User.count
    @balance_sum = User.sum(:balance)
    respond_to do |format|
      format.html { }
      format.json { render json: { user_count: @user_count, balance_sum: @balance_sum } }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :balance, :active)
  end

  def redirect(user = users_url)
    respond_to do |format|
      format.html { redirect_to user }
      format.json { head :no_content }
    end
  end
end
