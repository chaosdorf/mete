require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# load the config
require 'yaml'
APP_CONFIG = YAML.load_file(File.expand_path('../../var/config.yaml', __FILE__))
