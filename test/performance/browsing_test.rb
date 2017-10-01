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

  test "drinks" do
    get '/drinks'
  end

  test "drinks/new" do
    get '/drinks/new'
  end

  test "users" do
    get '/users'
  end

  test "users/new" do
    get '/users/new'
  end
  
  test "stats" do
    get '/users/stats'
  end
  
  test "barcodes" do
    get '/barcodes'
  end
  
  test "barcodes/new" do
    get '/barcodes/new'
  end

  # API v1
  test "users.json" do
    get '/api/v1/users.json'
  end
  
  test "users/new.json" do
    get '/api/v1/users/new.json'
  end
  
  test "barcodes.json" do
    get '/api/v1/barcodes.json'
  end
  
  test "barcodes/new.json" do
    get '/api/v1/barcodes/new.json'
  end
  
  test "drinks.json" do
    get '/api/v1/drinks.json'
  end
  
  test "drinks/new.json" do
    get '/api/v1/drinks/new.json'
  end
  
  test "audits.json" do
    get '/api/v1/audits.json'
  end

end
