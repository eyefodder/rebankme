source 'https://rubygems.org'

ruby '2.1.2'
#ruby-gemset=rebankme

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

gem 'pg'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'compass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Clearer printing of error pages
gem 'better_errors'
gem 'binding_of_caller'

# Annotates model files
gem 'annotate', '>=2.5.0'

# allow for SASSy bootstrap css
gem 'bootstrap-sass', '~> 3.2.0'
# gem "twitter-bootstrap-rails"

# add vendor prefixes in the asset pipeline
gem 'autoprefixer-rails'


gem 'rack-rewrite'
gem 'rails_12factor' #prevents deprecation warnings on heroku


gem 'going_postal' #zipcode *format* validation
gem 'geocoder' #address lookup

gem 'devise' #authentication framework


gem 'vanity', '2.0.0beta2' #metrics tracking
gem 'redis' #redis
gem 'redis-namespace'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end


gem 'quiet_assets', group: :development


#logging
gem 'logging'

#tracking
gem 'analytical'

#background processing - for sending emails
gem 'delayed_job_active_record'
#ui for delayed job
gem "delayed_job_web"
gem 'daemons'

group :development, :test do
	gem 'rspec-rails', '~> 2.14'
	gem 'guard-rspec', require: false
	gem 'spork-rails', '4.0.0'
	gem 'guard-spork', '1.5.0'
	gem 'ci_reporter'
	gem 'ci_reporter_rspec'
	gem 'launchy'
	gem 'database_cleaner'
	gem "therubyracer"
end

group :test do
	gem "codeclimate-test-reporter", require: nil
	gem 'selenium-webdriver', '~> 2.42.0'
	gem 'capybara', '~> 2.3.0'
	gem 'factory_girl_rails'


	# Uncomment this line on OS X.
	gem 'growl', '1.0.3'
 	# Uncomment these lines on Linux.
	gem 'ruby_gntp'

	# Uncomment these lines on Windows.
	# gem 'rb-notifu', '0.0.4'
	# gem 'win32console', '1.3.2'
	# gem 'wdm', '0.1.0'

	gem 'simplecov'
	gem 'simplecov-rcov'

	gem 'shoulda-matchers', require: false
	gem 'rspec-html-matchers'
end
