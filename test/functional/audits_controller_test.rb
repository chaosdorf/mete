require 'test_helper'

class AuditsControllerTest < ActionController::TestCase

  test "should get audits" do
    get :index
    assert_response :success
    assert_not_nil(:audits)
  end

  test "should get audits as json" do
    get :index, :format => "json"
    assert_response :success
    # The following line is the test.
    resp = JSON.parse(response.body)
    assert_not_nil resp["audits"]
  end

  test "should get no audits" do
    # This is way back in the past.
    @date = {
      "year"  => 1970,
      "month" => 1,
      "day"   => 1
    }
    get :index, start_date: @date, end_date: @date, :format => "json"
    assert_response :success
    resp = JSON.parse(response.body)
    assert_equal [], resp["audits"]
  end

end
