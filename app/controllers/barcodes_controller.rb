class BarcodesController < ApplicationController
  # GET /barcodes
  # GET /barcodes.json
  def index
    @barcodes = Barcode.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @barcodes }
    end
  end
  
  # GET /barcodes/new
  # GET /barcodes/new.json
  def new
    @barcode = Barcode.new
    if params.key?(:id)
      @barcode.id = params[:id]
    end
    if params.key?(:drink)
      @barcode.drink = params[:drink]
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @barcode }
    end
  end
  
  # POST /barcodes
  # POST /barcodes.json
  def create
    @barcode = Barcode.new(barcode_params)
    if Barcode.where(id: @barcode.id).exists?
      respond_to do |format|
        flash[:danger] = "This barcode does already exist."
        format.html { redirect_to new_barcode_path(barcode_params) }
        format.json { render json: {"error" => "This barcode does already exist."}, status: :unprocessable_entity }
      end
      return
    end
    unless Drink.where(id: @barcode.drink).exists?
      respond_to do |format|
        flash[:danger] = "This drink does not exist."
        format.html { redirect_to new_barcode_path(barcode_params) }
        format.json { render json: {"error" => "This drink does not exist."}, status: :unprocessable_entity }
      end
      return
    end
    if @barcode.save
      respond_to do |format|
        format.html { redirect_to barcodes_path, notice: 'Barcode was successfully created.' }
        format.json { render json: @barcode, status: :created, location: @barcode }
      end
    else
      respond_to do |format|
        flash[:danger] = "Couldn't create the barcode. Error: #{@barcode.errors} Status: #{:unprocessable_entity}"
        format.html { redirect_to new_barcode_path }
        format.json { render json: @barcode.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /barcodes/1234
  # DELETE /barcodes/1234.json
  def destroy
    @barcode = Barcode.find(params[:id])
    if @barcode.destroy
      flash[:success] = "Barcode was successfully deleted."
      no_resp_redir barcodes_path
    else
      respond_to do |format|
        format.html { redirect_to barcodes_path, error: "Couldn't delete the barcode. Error: #{@barcode.errors} Status: #{:unprocessable_entity}" }
        format.json { render json: @barcode.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def barcode_params
    params.require(:barcode).permit(:id, :drink)
  end
end
