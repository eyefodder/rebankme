# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
# @see http://www.schneems.com/post/15948562424/speed-up-capybara-tests-with-devise/
# @see https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
include Warden::Test::Helpers
Warden.test_mode!
def as_admin(user = nil, &block)
  user ||= AdminUser.first_or_create!(email: 'test@example.com',
                                      password: 'changeme',
                                      password_confirmation: 'changeme')
  current_admin_user = user
  if !request.try(:nil?) && request.try(:present?)
    sign_in(current_admin_user)
  else
    login_as(current_admin_user, scope: :admin_user, run_callbacks: false)
  end
  block.call if block.present?
  self
end

def as_visitor(&block)
  if request.present?
    sign_out(current_user)
  else
    logout(:admin_user)
  end
  block.call if block.present?
  self
end
