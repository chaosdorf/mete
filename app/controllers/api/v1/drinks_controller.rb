class Api::V1::DrinksController < ApplicationController
  # GET /drinks.json
  def index
    @drinks = Drink.order(active: :desc).order_by_name_asc
    render json: @drinks
  end

  # GET /drinks/1.json
  def show
    @drink = Drink.find(params[:id])
    render json: @drink
  end

  # GET /drinks/new.json
  def new
    @drink = Drink.new
    render json: @drink
  end

  # POST /drinks.json
  def create
    @drink = Drink.new(drink_params)
    if @drink.save
      render json: @drink, status: :created, location: @drink
    else
      render json: @drink.errors, status: :unprocessable_entity
    end
  end

  # PATCH /drinks/1.json
  def update
    @drink = Drink.find(params[:id])
    if @drink.update(drink_params)
      head :no_content
    else
      render json: @drink.errors, status: :unprocessable_entity
    end
  end

  # DELETE /drinks/1.json
  def destroy
    @drink = Drink.find(params[:id])
    Barcode.where(:drink => @drink.id).each do |barcode|
      barcode.destroy!
    end
    if @drink.destroy
      head :no_content
    else
      render json: @drink.errors, status: :unprocessable_entity
    end
  end

  private

  def drink_params
    params.require(:drink).permit(:bottle_size, :caffeine, :price, :logo, :name, :active)
  end
end
