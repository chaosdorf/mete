require 'test_helper'

class Api::V1::BarcodesControllerTest < ActionController::TestCase
  setup do
    @barcode = barcodes(:one)
    @drink = drinks(:one)
  end
  
  test "should get index as json" do
    get :index
    assert_response :success
    resp = JSON.parse(response.body)
    assert_not_nil resp
  end
  
  test "should get new as json" do
    get :new
    assert_response :success
    resp = JSON.parse(response.body)
    assert_not_nil resp
    assert_equal nil, resp["id"]
    assert_equal nil, resp["drink"]
  end
  
  test "should get new with drink as json" do
    get :new, params: {drink: @drink.id}
    assert_response :success
    resp = JSON.parse(response.body)
    assert_not_nil resp
    assert_equal nil, resp["id"]
    assert_equal @drink.id, resp["drink"]
  end
  
  test "should get new with id as json" do
    get :new, params: {id: @barcode.id}
    assert_response :success
    resp = JSON.parse(response.body)
    assert_not_nil resp
    assert_equal @barcode.id, resp["id"]
    assert_equal nil, resp["drink"]
  end
  
  test "should get new with id and drink as json" do
    get :new, params: {id: @barcode.id, drink: @drink.id}
    assert_response :success
    resp = JSON.parse(response.body)
    assert_not_nil resp
    assert_equal @barcode.id, resp["id"]
    assert_equal @drink.id, resp["drink"]
  end
  
  test "should create barcode as json" do
    assert_difference('Barcode.count') do
      post :create, params: {barcode: {id: "abcdef", drink: @drink}}
    end
    assert_response :created
    resp = JSON.parse(response.body)
    assert_not_nil resp
    assert_equal "abcdef", resp["id"]
    assert_equal @drink.id, resp["drink"]
  end
  
  test "should destroy barcode as json" do
    assert_difference('Barcode.count', -1) do
      delete :destroy, params: {id: @barcode}
    end
    assert_response :no_content
  end
end
