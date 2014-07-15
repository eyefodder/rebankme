# @see http://www.schneems.com/post/15948562424/speed-up-capybara-tests-with-devise/
# @see https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
include Warden::Test::Helpers
Warden.test_mode!



def as_admin(user=nil, &block)
  current_admin_user = user || AdminUser.first
  # current_admin_user = user || FactoryGirl.create(:admin_user)
  if !request.try(:nil?) && request.try(:present?)
    sign_in(current_admin_user)
  else
    login_as(current_admin_user, :scope => :admin_user, :run_callbacks => false)
  end


  block.call if block.present?
  return self
end

# Will run the given code as the user passed in
# def as_user(user=nil, &block)
#   current_user = user || FactoryGirl.create(:user)
#   if !request.try(:nil?) && request.try(:present?)
#     sign_in(current_user)
#   else
#     login_as(current_user, :scope => :user, :run_callbacks => false)
#   end
#   block.call if block.present?
#   return self
# end

# def login_legacy_user(user)
#   page.set_rack_session(:user_id => user.id)
# end

# def irb_user(user=nil, &block)
#   current_user = user || FactoryGirl.create(:legacy_user)

#     login_as(current_user, :scope => :user)

#   block.call if block.present?
#   return self
# end


def as_visitor(user=nil, &block)
  current_admin_user = user || FactoryGirl.stub(:admin_user)
  if request.present?
    sign_out(current_user)
  else
    logout(:admin_user)
  end
  block.call if block.present?
  return self
end