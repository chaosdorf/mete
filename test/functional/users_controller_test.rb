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
      post :create, params: {user: { balance: @user.balance, name: @user.name }}
    end
    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user with email" do
    get :show, params: {id: @user}
    assert_response :success
  end

  test "should show user without email" do
    get :show, params: {id: users(:two)}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @user}
    assert_response :success
  end

  test "deposit" do
    get :deposit, params: {id: @user, amount: 100}
    assert_equal 200, User.find(@user.id).balance
    assert_equal 100, Audit.first.difference
  end

  test "payment" do
    get :payment, params: {id: @user, amount: 100}
    assert_equal 0, User.find(@user.id).balance
    assert_equal -100, Audit.first.difference
  end

  test "payment resulting in a negative balance" do
    get :payment, params: {id: users(:two), amount: 100}
    assert_equal -100, User.find(users(:two).id).balance
    assert_equal -100, Audit.first.difference
  end

  test "buy" do
    assert_difference('Audit.count') do
      get :buy, params: {id: @user, drink: @drink}
    end
    assert_equal -@drink.price, Audit.first.difference
    assert_redirected_to users_path
  end

  test "buy resulting in a negative balance" do
    assert_difference('Audit.count') do
      get :buy, params: {id: users(:two), drink: @drink}
    end
    assert_equal -@drink.price, User.find(users(:two).id).balance
    assert_equal -@drink.price, Audit.first.difference
  end

  test "buy unavailable drink" do
    assert_equal Drink.find(drinks(:two).id).active, false
    get :buy, params: {id: @user, drink: drinks(:two)}
    assert_equal Drink.find(drinks(:two).id).active, true
    assert_equal -drinks(:two).price, Audit.first.difference
    assert_redirected_to users_path
  end
  
  test "buy resulting in unidentifiable audit" do
    get :buy, params: {id: @user, drink: @drink}
    assert_nil Audit.first.user
  end
  
  test "buy with logging enabled resulting in identifiable audit" do
    get :buy, params: {id: users(:two), drink: @drink}
    assert_equal users(:two).id, Audit.first.user
  end

  test "should show stats" do
    get :stats
    assert_response :success
    assert_not_nil assigns(:user_count)
    assert_not_nil assigns(:balance_sum)
  end

  test "should update user" do
    put :update, params: {id: @user, user: { balance: @user.balance, name: @user.name }}
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, params: {id: @user}
    end
    assert_redirected_to users_path
  end
end
