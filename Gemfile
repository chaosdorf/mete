source 'https://rubygems.org'
git_source(:github){ |repo_name| "https://github.com/#{repo_name}.git" }

gem 'rails', '~> 7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

gem 'sassc-rails'
gem 'coffee-rails'
gem 'bootstrap', "~> 5"

gem 'uglifier'

gem 'jquery-rails'
gem 'haml-rails'
gem 'gravatar_image_tag', git: 'https://github.com/chaosdorf/gravatar_image_tag'
gem 'kt-paperclip'
gem 'simple_form'
gem 'favicon_maker'
gem 'mini_magick'
gem 'puma'
gem 'autoprefixer-rails'
gem 'rails-controller-testing'
gem 'bootsnap'
gem 'git_rev'

gem "codeclimate-test-reporter", group: :test, require: nil

# work around a bug in Debian (https://github.com/rails/thor/issues/721)
gem 'thor', '~> 1.0.1'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# To use debugger
# gem 'debugger'
#
#
gem 'sentry-ruby'
gem 'sentry-rails'

# To toot purchases to Mastodon
gem 'httparty'

group :development do
  gem 'faker'
  gem 'ruby-prof'
  gem 'spring'
  gem 'minitest', '< 5.11'
end

group :production do
  gem 'SyslogLogger'
  gem 'pg'
end
