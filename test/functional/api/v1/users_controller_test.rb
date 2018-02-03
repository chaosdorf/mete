require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @drink = drinks(:one)
    @barcode = barcodes(:one)
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
    assert_nil resp["email"]
    assert_nil resp["created_at"]
    assert_nil resp["updated_at"]
    assert_equal "0.0", resp["balance"]
    assert_equal true, resp["active"]
    assert_equal false, resp["audit"]
    assert_equal true, resp["redirect"]
  end

  test "should create user as json" do
    assert_difference('User.count', 1) do
      post :create, params: {user: { balance: @user.balance, name: @user.name }}
    end
    assert_response :created
    resp = JSON.parse(response.body)
    assert_not_nil resp
    assert_equal @user.name, resp["name"]
    assert_equal @user.balance.to_s, resp["balance"]
  end

  test "should show user with email as json" do
    get :show, params: {id: @user}
    assert_response :success
    resp = JSON.parse(response.body)
    assert_not_nil resp
    assert_equal @user.name, resp["name"]
    assert_equal @user.email, resp["email"]
  end

  test "should show user without email" do
    get :show, params: {id: users(:two)}
    assert_response :success
    resp = JSON.parse(response.body)
    assert_not_nil resp
    assert_equal users(:two).name, resp["name"]
    assert_nil resp["email"]
  end

  test "deposit as json" do
    get :deposit, params: {id: @user, amount: 100}
    assert_equal 200, User.find(@user.id).balance
    assert_equal 100, Audit.first.difference
    assert_response :no_content
  end

  test "payment as json" do
    get :payment, params: {id: @user, amount: 100}
    assert_equal 0, User.find(@user.id).balance
    assert_equal -100, Audit.first.difference
    assert_response :no_content
  end

  test "buy as json" do
    assert_difference('Audit.count') do
      get :buy, params: {id: @user, drink: @drink}
    end
    assert_equal -@drink.price, Audit.first.difference
    assert_response :no_content
  end
  
  test "buy by barcode as json" do
    assert_difference('Audit.count') do
      post :buy_barcode, params: {id: @user, barcode: @barcode}
    end
    assert_equal -@drink.price, Audit.first.difference
    assert_response :no_content
  end
  
  test "should show stats as json" do
    get :stats
    assert_response :success
    resp = JSON.parse(response.body)
    assert_not_nil resp
    assert_not_nil resp["user_count"]
    assert_not_nil resp["balance_sum"]
  end

  test "should update user as json" do
    put :update, params: {id: @user, user: { balance: @user.balance, name: @user.name }}
    assert_response :no_content
  end

  test "should destroy user as json" do
    assert_difference('User.count', -1) do
      delete :destroy, params: {id: @user}
    end
    assert_response :no_content
  end
end
