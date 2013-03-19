class DrinksController < ApplicationController
  # GET /drinks
  # GET /drinks.json
  def index
    @drinks = Drink.all

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
    @drink = Drink.new(params[:drink])

    respond_to do |format|
      if @drink.save
        format.html { redirect_to @drink, notice: 'Drink was successfully created.' }
        format.json { render json: @drink, status: :created, location: @drink }
      else
        format.html { render action: "new" }
        format.json { render json: @drink.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /drinks/1
  # PUT /drinks/1.json
  def update
    @drink = Drink.find(params[:id])

    respond_to do |format|
      if @drink.update_attributes(params[:drink])
        format.html { redirect_to @drink, notice: 'Drink was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @drink.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drinks/1
  # DELETE /drinks/1.json
  def destroy
    @drink = Drink.find(params[:id])
    @drink.destroy

    respond_to do |format|
      format.html { redirect_to drinks_url }
      format.json { head :no_content }
    end
  end
end
