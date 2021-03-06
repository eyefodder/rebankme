# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)
module Rebankme
  # main app class
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names.
    # Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from
    # config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales',
    # '*.{rb,yml}').to_s]
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :en
    config.i18n.load_path += Dir[Rails.root.join('config',
                                                 'locales',
                                                 '**',
                                                 '*.{rb,yml}')]

    config.autoload_paths << Rails.root.join('lib')

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              ENV['MAILER_ADDRESS'],
      port:                 ENV['MAILER_PORT'],
      domain:               ENV['MAILER_DOMAIN'],
      user_name:            ENV['MAILER_USERNAME'],
      password:             ENV['MAILER_PASSWORD'],
      authentication:       'plain',
      enable_starttls_auto: true  }

    # load redis gem
    config.gem 'redis-namespace', lib: 'redis/namespace'
    config.gem 'redis'

    config.force_ssl = false
  end
end
