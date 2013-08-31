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
    assert_difference('Drink.count') do
      post :create, drink: { bottle_size: @drink.bottle_size, caffeine: @drink.caffeine, donation_recommendation: @drink.donation_recommendation, logo_url: @drink.logo_url, name: @drink.name }
    end

    assert_redirected_to drink_path(assigns(:drink))
  end

  test "should show drink" do
    get :show, id: @drink
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @drink
    assert_response :success
  end

  test "should update drink" do
    put :update, id: @drink, drink: { bottle_size: @drink.bottle_size, caffeine: @drink.caffeine, donation_recommendation: @drink.donation_recommendation, logo_url: @drink.logo_url, name: @drink.name }
    assert_redirected_to drink_path(assigns(:drink))
  end

  test "should destroy drink" do
    assert_difference('Drink.count', -1) do
      delete :destroy, id: @drink
    end

    assert_redirected_to drinks_path
  end
end
