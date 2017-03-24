require 'test_helper'

class BarcodesControllerTest < ActionController::TestCase
  setup do
    @barcode = barcodes(:one)
    @drink = drinks(:one)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:barcodes)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should get new with drink" do
    get :new, params: {drink: @drink.id}
    assert_response :success
  end
  
  test "should get new with id" do
    get :new, params: {id: @barcode.id}
    assert_response :success
  end
  
  test "should get new with id and drink" do
    get :new, params: {id: @barcode.id, drink: @drink.id}
  end
  
  test "should create barcode" do
    assert_difference('Barcode.count') do
      post :create, params: {barcode: {id: "abcdef", drink: @drink}}
    end
    assert_redirected_to barcodes_path
  end
  
  test "should destroy barcode" do
    assert_difference('Barcode.count', -1) do
      delete :destroy, params: {id: @barcode}
    end
    assert_redirected_to barcodes_path
  end
end
