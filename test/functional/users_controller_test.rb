require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @drink = drinks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { balance: @user.balance, name: @user.name }
    end
    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "deposit" do
    get :deposit, id: @user, amount: 100
    assert_equal 200, User.find(@user.id).balance
    assert_equal 100, Audit.first.difference
  end

  test "payment" do
    get :payment, id: @user, amount: 100
    assert_equal 0, User.find(@user.id).balance
    assert_equal -100, Audit.first.difference
  end

  test "buy" do
    get :buy, id: @user, drink: @drink
    assert_equal -@drink.price, Audit.first.difference
    assert_redirected_to users_path
  end

  test "should show stats" do
    get :stats
    assert_response :success
    assert_not_nil assigns(:user_count)
    assert_not_nil assigns(:balance_sum)
  end

  test "should update user" do
    put :update, id: @user, user: { balance: @user.balance, name: @user.name }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end
    assert_redirected_to users_path
  end
end
