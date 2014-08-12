# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start


require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  # unless ENV['DRB']
  #   require 'simplecov'
  #   require 'simplecov-rcov'
  #   SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  #   # SimpleCov.start 'rails'
  # end
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    CodeClimate::TestReporter::Formatter,
    SimpleCov::Formatter::RcovFormatter,
  ]

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'shoulda/matchers'
  require 'rspec/autorun'
  # require "rack_session_access/capybara"

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  Dir[Rails.root.join("spec/features/steps/**/*.rb")].each {|f|
    require f
  }

  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  # commented out as its a rails 4.0 feature
  # ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    # config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
    # config.include IntegrationMacros
    config.include Capybara::DSL

    config.include FactoryGirl::Syntax::Methods

    config.include ActionView::Helpers::TextHelper

    config.include I18n


    config.include ActionView::TestCase::Behavior, example_group: {file_path: %r{spec/presenters}}
    config.include ActionView::TestCase::Behavior, example_group: {file_path: %r{spec/requests}}


    config.use_transactional_fixtures = true

    DatabaseCleaner.strategy = :truncation

    config.before(:suite) do

      DatabaseCleaner.clean


      Geocoder.configure(:lookup => :test)
      Geocoder::Lookup::Test.set_default_stub([])
      Geocoder::Lookup::Test.add_stub( '00000', [])
      Geocoder::Lookup::Test.add_stub(
        '34000', [
          {
            'latitude'     => 43.6047275,
            'longitude'    => 3.941479699999999,
            'country_code' => 'FR'
          }
        ]
        )
      Geocoder::Lookup::Test.add_stub(
        '97206', [
          {
            'latitude'     => 44.2875783,
            'longitude'    => -121.6724376,
            'country_code' => 'US',
            'state_code' => 'OR'
          }
        ]
        )
      Geocoder::Lookup::Test.add_stub(
        '11205', [
          {
            'latitude'     => 40.6945036,
            'longitude'    => -73.9565551,
            'country_code' => 'US',
            'state_code'   => 'NY',
          }
        ]
        )
      Geocoder::Lookup::Test.add_stub(
        '10463', [
          {
            'latitude'     => 40.8803247,
            'longitude'    => -73.9095279,
            'country_code' => 'US'
          }
        ]
        )
      Geocoder::Lookup::Test.add_stub(
        '90210', [
          {
            'latitude'     => 34.103002,
            'longitude'    => -118.4104684,
            'country_code' => 'US'
          }
        ]
        )
      Geocoder::Lookup::Test.add_stub(
        '11205-4407', [
          {
            'latitude'     => 40.6945036,
            'longitude'    => -73.9565551,
            'country_code' => 'US'
          }
        ]
        )


    end

    config.before(:all) do
      FactoryGirl.lint
      Rails.application.load_seed
    end

    # config.after(:each) { Warden.test_reset! }

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
    config.after(:each) { Warden.test_reset! }

    # http://blog.zerosum.org/2011/03/19/easy-rails-outh-integration-testing.html
    # config.include IntegrationSpecHelper, :type => :request
    # config.include IntegrationSpecHelper, :type => :bookmarklet

# https://github.com/plataformatec/devise/wiki/How-To:-Controllers-tests-with-Rails-3-(and-rspec)
    # config.include Devise::TestHelpers, :type => :controller

    # config.include ActionView::TestCase::Behavior, example_group: {file_path: %r{spec/presenters}}
# http://stackoverflow.com/questions/13420923/configuring-warden-for-use-in-rspec-controller-specs
    # config.include Warden::Test::ControllerHelpers

    # @see http://stackoverflow.com/questions/12512108/can-i-access-application-helper-methods-in-a-rspec-request
    # bu must test helper methods too!

   # config.include ApplicationHelper

 end
 Capybara.default_host = 'http://example.org'

  # OmniAuth.config.test_mode = true
  # OmniAuth.config.add_mock(:twitter, {
  #   :uid => '12345',
  #   :info => {nickname: 'poop', name: 'test name', urls:{Twitter: 'http://some-twitter-url.com'}},
  #   :credentials => {}
  #   })

end

Spork.each_run do
  # if ENV['DRB']
  #   require 'simplecov'
  #   require 'simplecov-rcov'
  #   SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  #   SimpleCov.start 'rails'
  # end
  # This code will be run each time you run your specs.
  # require 'rspec/rails'
  # require 'shoulda/matchers'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    CodeClimate::TestReporter::Formatter,
    SimpleCov::Formatter::RcovFormatter,
  ]
end