module PathMatchers
  extend RSpec::Matchers::DSL

  RSpec::Matchers.define :be_request_email_path do
    match do |current_path|
      current_path.match('^\/users\/[0-9]+\/request_email$')
    end
  end

  RSpec::Matchers.define :be_find_account_path do
    match do |current_path|
      current_path.match('^\/users\/[0-9]+\/find_account$')
    end
  end

end