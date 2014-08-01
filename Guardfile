

notification :gntp, :sticky => false, :host => '10.0.1.28', :password => 'password'
# notification :gntp, :sticky => false, :host => '192.168.200.208', :password => 'password'

require 'active_support/core_ext'

guard 'rspec', all_after_pass: false, failed_mode: :none , cmd: 'rspec --fail-fast --drb' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  watch(%r{^app/presenters/(.+)_presenter\.rb$}) do |m|
    ["spec/presenters/#{m[1]}_presenter_spec.rb",
    (m[1][/_pages/] ? "spec/requests/#{m[1]}_spec.rb" : "spec/requests/#{m[1].singularize}_pages_spec.rb"),
    (m[1][/_pages/] ? "spec/requests/js_specific/#{m[1]}_spec.rb" : "spec/requests/js_specific/#{m[1].singularize}_pages_spec.rb")
  ]
end

watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
  ["spec/routing/#{m[1]}_routing_spec.rb",
  "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
  "spec/acceptance/#{m[1]}_spec.rb",
  (m[1][/_pages/] ? "spec/requests/#{m[1]}_spec.rb" : "spec/requests/#{m[1].singularize}_pages_spec.rb"),
  (m[1][/_pages/] ? "spec/requests/js_specific/#{m[1]}_spec.rb" : "spec/requests/js_specific/#{m[1].singularize}_pages_spec.rb")
]
end
watch(%r{^app/views/(.+)/}) do |m|
  [(m[1][/_pages/] ? "spec/requests/#{m[1]}_spec.rb" :
    "spec/requests/#{m[1].singularize}_pages_spec.rb"),
  (m[1][/_pages/] ? "spec/requests/js_specific/#{m[1]}_spec.rb" :
   "spec/requests/js_specific/#{m[1].singularize}_pages_spec.rb")
]
end



watch(%r{^app/factories/(.+)\.rb$}) do |m|

  "spec/factory_tests/#{m[1]}_spec.rb"
end

  #localization tests
  watch(%r{^config/locales/(.+)/(.+)\.yml$}) do |m|
    "spec/localization/#{m[1]}_spec.rb"
  end


  watch(%r{^app/controllers/sessions_controller\.rb$}) do |m|
    "spec/requests/authentication_pages_spec.rb"
  end
  #end custom specs...

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})     { |m| "spec/features/#{m[1]}_spec.rb" }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
end

guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' },
:rspec_env    => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/routes.rb')
  watch('config/environments/test.rb')
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('test/test_helper.rb') { :test_unit }
  watch(%r{features/support/}) { :cucumber }
  watch(%r{^spec/support/.+\.rb})
  watch(%r{^spec/factories.rb})
  watch(%r{^spec/features/steps/.+\.rb})
end

