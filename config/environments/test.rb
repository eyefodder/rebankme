Rebankme::Application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is 'scratch space' for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance.
  config.serve_static_assets  = true
  config.static_cache_control = 'public, max-age=3600'

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test
  config.action_mailer.smtp_settings = {
    address:              'smtp.example.com',
    port:                 587,
    domain:               'example.com',
    user_name:            'username@example.com',
    password:             'password',
    authentication:       'plain',
    enable_starttls_auto: true  }

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  config.log_level = :error

  ENV['VANITY_DISABLED'] = 'true'
  # rubocop:disable all
  ENV['SECRET_TOKEN'] = 'dd7d6bd0314aa5dddc0e74b2f6c39f1aac1d4e3e9835f60e4cc2a53a72aa0fbabfe1fff0f3246f8ff67dc470a2020eff369bc40449a0be04aafeefeecb161fd0'
  # rubocop:enable all
end
