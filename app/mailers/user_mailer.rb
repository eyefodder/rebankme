# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  default from: ActionMailer::Base.smtp_settings[:user_name]

  def cc_recipient
    ActionMailer::Base.smtp_settings[:user_name]
  end

  def help_request_recipient
    @rebank_recipient ||= ENV['MAILER_REBANK_RECIPIENT']
    @rebank_recipient ||= 'test@example.com'
  end

  def notify_of_user_help_request(user_id, account_type_id)
    @user = User.find(user_id)
    @account_type = AccountType.find(account_type_id)
    mail(to: help_request_recipient,
         cc: cc_recipient,
         subject: "#{@account_type.name} help request from #{@user.email}")
  end
end
