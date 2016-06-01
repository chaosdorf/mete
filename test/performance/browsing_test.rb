require 'test_helper'
require 'rails/performance_test_help'
require 'rails/perftest/action_dispatch'

class BrowsingTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

  def test_homepage
    get '/'
  end

  def test_audits
    get '/audits'
  end

  def test_audits_json
    get '/audits.json'
  end

  def test_drinks
    get '/drinks'
  end

  def test_drinks_json
    get '/drinks.json'
  end

  def test_users
    get '/users'
  end

  def test_users_json
    get '/users.json'
  end

end
