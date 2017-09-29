class DrinksController < ApplicationController
  # GET /drinks
  # GET /drinks.json
  def index
    @drinks = Drink.order(active: :desc).order("name COLLATE nocase")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @drinks }
    end
  end

  # GET /drinks/1
  # GET /drinks/1.json
  def show
    @drink = Drink.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @drink }
    end
  end

  # GET /drinks/new
  # GET /drinks/new.json
  def new
    @drink = Drink.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @drink }
    end
  end

  # GET /drinks/1/edit
  def edit
    @drink = Drink.find(params[:id])
  end

  # POST /drinks
  # POST /drinks.json
  def create
    @drink = Drink.new(drink_params)
    respond_to do |format|
      if @drink.save
        format.html { redirect_to @drink, notice: 'Drink was successfully created.' }
        format.json { render json: @drink, status: :created, location: @drink }
      else
        format.html { render action: "new", error: "Couldn't create the drink. Error: #{@drink.errors} Status: #{:unprocessable_entity}" }
        format.json { render json: @drink.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /drinks/1
  # PATCH /drinks/1.json
  def update
    @drink = Drink.find(params[:id])
    if @drink.update_attributes(drink_params)
      flash[:success] = "Drink was successfully updated."
      no_resp_redir @drink
    else
      respond_to do |format|
        format.html { render action: "edit", error: "Couldn't update the drink. Error: #{@drink.errors} Status: #{:unprocessable_entity}" }
        format.json { render json: @drink.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drinks/1
  # DELETE /drinks/1.json
  def destroy
    @drink = Drink.find(params[:id])
    Barcode.where(:drink => @drink.id).each do |barcode|
      barcode.destroy!
      flash[:info] = "Deleted all barcodes for this drink."
    end
    if @drink.destroy
      flash[:success] = "Drink was successfully deleted."
      no_resp_redir drinks_url
    else
      respond_to do |format|
        format.html { redirect_to drinks_url, error: "Couldn't delete the drink. Error: #{@drink.errors} Status: #{:unprocessable_entity}" }
        format.json { render json: @drink.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def drink_params
    params.require(:drink).permit(:bottle_size, :caffeine, :price, :logo, :name, :active)
  end
end
