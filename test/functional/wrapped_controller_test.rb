require 'test_helper'

class WrappedControllerTest < ActionController::TestCase
  setup do
    @user = users(:two)
    @year = Date.today.year
    @drink = drinks(:one)
    @user.buy @drink
  end

  test 'should get empty index' do
    get :index, params: { user_id: users(:one) }
    assert_response :success
    assert_empty assigns(:years)
  end

  test 'should get populated index' do
    get :index, params: { user_id: @user }
    assert_response :success
    assert_equal [@year], assigns(:years)
  end
  
  test 'should get empty page' do
    get :show, params: { user_id: users(:one), id: @year }
    assert_response :success
    assert assigns(:empty)
  end
  
  test 'should get populated page' do
    get :show, params: { user_id: @user, id: @year }
    assert_response :success
    assert !assigns(:empty)
    assert_equal(
      { drink: @drink, count: 1, user_more: 0 },
      assigns(:most_bought_drink)
    )
    assert_equal(
      { total: @drink.caffeine, would_kill: 'hamster' },
      assigns(:caffeine)
    )
    assert_equal(
      { weekday: Date.today.strftime('%A'), hour: DateTime.now.utc.hour },
      assigns(:most_active)
    )
  end
end
