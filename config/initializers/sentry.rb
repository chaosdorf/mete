Sentry.init do |config|
  config.enabled_environments = ['production']
  if File.file?("/run/secrets/SENTRY_DSN")
    config.dsn = File.read("/run/secrets/SENTRY_DSN").strip
  end
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
end
