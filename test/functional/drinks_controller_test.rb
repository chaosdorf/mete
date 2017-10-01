require 'test_helper'

class DrinksControllerTest < ActionController::TestCase
  setup do
    @drink = drinks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drinks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create drink" do
    assert_difference('Drink.count', 1) do
      post :create, params: {drink: { bottle_size: @drink.bottle_size, caffeine: @drink.caffeine, price: @drink.price, logo_file_name: @drink.logo_file_name, name: @drink.name }}
    end

    assert_redirected_to drink_path(assigns(:drink))
  end

  test "should show drink" do
    get :show, params: {id: @drink}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @drink}
    assert_response :success
  end

  test "should update drink" do
    put :update, params: {id: @drink, drink: { bottle_size: @drink.bottle_size, caffeine: @drink.caffeine, price: @drink.price, logo_file_name: @drink.logo_file_name, name: @drink.name }}
    assert_redirected_to drink_path(assigns(:drink))
  end

  test "should destroy drink" do
    assert_difference('Drink.count', -1) do
      delete :destroy, params: {id: drinks(:two)}
    end

    assert_redirected_to drinks_path
  end
  
  test "should destroy drink with barcodes" do
    assert_difference('Drink.count', -1) do
      assert_difference('Barcode.count', -1) do
        delete :destroy, params: {id: @drink}
      end
    end
    assert_redirected_to drinks_path
  end
end
