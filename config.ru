# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

root = if ENV['RAILS_RELATIVE_URL_ROOT'] != nil
    if ENV['RAILS_RELATIVE_URL_ROOT'] != '/' and ENV['RAILS_RELATIVE_URL_ROOT'].end_with? '/'
        raise 'Invalid environment variable RAILS_RELATIVE_URL_ROOT `%s`. '\
            'Please remove any trailing slashes!' %[ENV['RAILS_RELATIVE_URL_ROOT']]
    end
    ENV['RAILS_RELATIVE_URL_ROOT']
else
    '/'
end

map root do
    run Mete::Application
end
