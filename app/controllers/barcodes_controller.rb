class BarcodesController < ApplicationController
  # GET /barcodes
  def index
    @barcodes = Barcode.all
    # index.html.haml
  end
  
  # GET /barcodes/new
  def new
    @barcode = Barcode.new
    if params.key?(:id)
      @barcode.id = params[:id]
    end
    if params.key?(:drink)
      @barcode.drink = params[:drink]
    end
    @drinks = Drink.order(active: :desc).order("name COLLATE nocase")
    # new.html.haml
  end
  
  # POST /barcodes
  def create
    @barcode = Barcode.new(barcode_params)
    if Barcode.where(id: @barcode.id).exists?
      flash[:danger] = "This barcode does already exist."
      redirect_to new_barcode_path(barcode_params)
      return
    end
    unless Drink.where(id: @barcode.drink).exists?
      flash[:danger] = "This drink does not exist."
      redirect_to new_barcode_path(barcode_params)
      return
    end
    if @barcode.save
      redirect_to barcodes_path, notice: 'Barcode was successfully created.'
    else
      flash[:danger] = "Couldn't create the barcode. Error: #{@barcode.errors} Status: #{:unprocessable_entity}"
      redirect_to new_barcode_path
    end
  end
  
  # DELETE /barcodes/1234
  def destroy
    @barcode = Barcode.find(params[:id])
    if @barcode.destroy
      flash[:success] = "Barcode was successfully deleted."
      no_resp_redir barcodes_path
    else
      redirect_to barcodes_path, error: "Couldn't delete the barcode. Error: #{@barcode.errors} Status: #{:unprocessable_entity}"
    end
  end
  
  private
  
  def barcode_params
    params.require(:barcode).permit(:id, :drink)
  end
end
