class Api::V1::BarcodesController < ApplicationController
  # GET /barcodes.json
  def index
    @barcodes = Barcode.all
    render json: @barcodes
  end
  
  # GET /barcodes/new.json
  def new
    @barcode = Barcode.new
    if params.key?(:id)
      @barcode.id = params[:id]
    end
    if params.key?(:drink)
      @barcode.drink = params[:drink]
    end
    render json: @barcode
  end
  
  # POST /barcodes.json
  def create
    @barcode = Barcode.new(barcode_params)
    if Barcode.where(id: @barcode.id).exists?
      render json: {"error" => "This barcode does already exist."}, status: :unprocessable_entity
      return
    end
    unless Drink.where(id: @barcode.drink).exists?
      render json: {"error" => "This drink does not exist."}, status: :unprocessable_entity
      return
    end
    if @barcode.save
      render json: @barcode, status: :created, location: @barcode
    else
      render json: @barcode.errors, status: :unprocessable_entity
    end
  end
  
  # DELETE /barcodes/1234.json
  def destroy
    @barcode = Barcode.find(params[:id])
    if @barcode.destroy
      head :no_content
    else
      render json: @barcode.errors, status: :unprocessable_entity
    end
  end
  
  private
  
  def barcode_params
    params.require(:barcode).permit(:id, :drink)
  end
end
