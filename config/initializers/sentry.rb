require "raven"

Raven.configure do |config|
  config.environments = ['production']
end
