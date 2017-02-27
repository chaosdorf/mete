require 'test_helper'
require 'rails/performance_test_help'
require 'rails/perftest/action_dispatch'

class BrowsingTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { :runs => 2, :metrics => [:wall_time, :memory],
                           :output => 'tmp/performance', :formats => [:flat] }

  test "homepage" do
    get '/'
  end

  test "audits" do
    get '/audits'
  end

  test "audits.json" do
    get '/audits.json'
  end

  test "drinks" do
    get '/drinks'
  end

  test "drinks.json" do
    get '/drinks.json'
  end
  
  test "drinks/new" do
    get '/drinks/new'
  end

  test "users" do
    get '/users'
  end

  test "users.json" do
    get '/users.json'
  end
  
  test "users/new" do
    get '/users/new'
  end
  
  test "stats" do
    get '/users/stats'
  end
  
  test "stats.json" do
    get '/users/stats.json'
  end

end
