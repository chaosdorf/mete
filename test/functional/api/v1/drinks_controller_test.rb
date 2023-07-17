require 'test_helper'

class Api::V1::DrinksControllerTest < ActionController::TestCase
  setup do
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
    assert_nil resp["id"]
    assert_nil resp["name"]
    assert_equal "0.0", resp["bottle_size"]
    assert_nil resp["caffeine"]
    assert_equal "1.5", resp["price"]
    assert_nil resp["logo_file_name"]
    assert_nil resp["logo_content_type"]
    assert_nil resp["logo_file_size"]
    assert_nil resp["logo_updated_at"]
    assert_equal "/logos/medium/missing.png", resp["logo_url"]
    assert_nil resp["created_at"]
    assert_nil resp["updated_at"]
    assert_equal true, resp["active"]
    assert_equal "1.5", resp["donation_recommendation"] # deprecated
  end

  test "should create drink as json" do
    assert_difference('Drink.count', 1) do
      post :create, params: {drink: { bottle_size: @drink.bottle_size, caffeine: @drink.caffeine, price: @drink.price, logo_file_name: @drink.logo_file_name, name: @drink.name }}
    end
    assert_response :created
    resp = JSON.parse(response.body)
    assert_not_nil resp
    assert_equal @drink.name, resp["name"]
    assert_equal @drink.bottle_size.to_s, resp["bottle_size"]
    assert_equal @drink.caffeine, resp["caffeine"]
    assert_equal @drink.price.to_s, resp["price"]
    assert_equal true, resp["active"]
    assert_equal @drink.price.to_s, resp["donation_recommendation"] # deprecated
  end

  test "should show drink as json" do
    get :show, params: {id: @drink}
    assert_response :success
    resp = JSON.parse(response.body)
    assert_not_nil resp
    assert_equal @drink.name, resp["name"]
    assert_equal @drink.bottle_size.to_s, resp["bottle_size"]
    assert_equal @drink.caffeine, resp["caffeine"]
    assert_equal @drink.price.to_s, resp["price"]
    assert_equal @drink.logo_file_name, resp["logo_file_name"]
    assert_equal true, resp["active"]
    assert_equal @drink.price.to_s, resp["donation_recommendation"] # deprecated
  end

  test "should update drink as json" do
    put :update, params: {id: @drink, drink: { bottle_size: @drink.bottle_size, caffeine: @drink.caffeine, price: @drink.price, logo_file_name: @drink.logo_file_name, name: @drink.name }}
    assert_response :no_content
  end

  test "should destroy drink as json" do
    assert_difference('Drink.count', -1) do
      delete :destroy, params: {id: drinks(:two)}
    end
    assert_response :no_content
  end
  
  test "should destroy drink with barcodes as json" do
    assert_difference('Drink.count', -1) do
      assert_difference('Barcode.count', -1) do
        delete :destroy, params: {id: @drink}
      end
    end
  assert_response :no_content
  end
end
