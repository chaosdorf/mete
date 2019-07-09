require "raven"

Raven.configure do |config|
  config.environments = ['production']
  if File.file?("/run/secrets/SENTRY_DSN")
    config.dsn = File.read("/run/secrets/SENTRY_DSN").strip
  end
end
