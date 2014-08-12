Rebankme::Application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # devise setup:
  config.action_mailer.default_url_options = { host: 'localhost:5000' }

  config.log_level = :debug

  ENV['REDISTOGO_URL'] = 'redis://127.0.0.1:6900/0'
  # rubocop:disable all
  ENV['SECRET_TOKEN'] = 'dd7d6bd0314aa5dddc0e74b2f6c39f1aac1d4e3e9835f60e4cc2a53a72aa0fbabfe1fff0f3246f8ff67dc470a2020eff369bc40449a0be04aafeefeecb161fd0'
  # rubocop:enable all
end
