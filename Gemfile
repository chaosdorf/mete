source 'https://rubygems.org'
git_source(:github){ |repo_name| "https://github.com/#{repo_name}.git" }

gem 'rails', '~> 5'

# https://github.com/rails/sprockets-rails/issues/131
#gem 'sprockets-rails', :require => 'sprockets/rails/version'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

gem 'sass-rails'
gem 'coffee-rails'
gem 'bootstrap-sass'

gem 'uglifier', '>= 1.0.3'

gem 'jquery-rails'
gem 'haml-rails'
gem 'gravatar_image_tag'
gem 'paperclip'
gem 'formtastic'
gem 'formtastic-bootstrap', :github => 'nickl-/formtastic-bootstrap3', :branch => 'bootstrap3'
gem 'bootswatch-rails'
gem 'favicon_maker'
gem 'mini_magick'
gem 'puma'
gem 'autoprefixer-rails'
gem 'rails-controller-testing'

gem "codeclimate-test-reporter", '~> 1', group: :test, require: nil

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# To use debugger
# gem 'debugger'
#
#
gem 'sentry-raven'

group :development do
  gem 'faker'
  gem 'rails-perftest'
  gem 'ruby-prof'
  gem 'spring'
  gem 'minitest', '< 5.11'
end

group :production do
  gem 'SyslogLogger'
  gem 'pg', '~> 0.18' # activerecord 5.1.4 requires this
end
