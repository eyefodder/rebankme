class UserMailer < ActionMailer::Base


  @@rebank_recipient
  # default from: ActionMailer::Base.smtp_settings.user_name



  def help_request_recipient
    @@rebank_recipient ||= ENV['MAILER_REBANK_RECIPIENT']
    @@rebank_recipient ||= 'test@example.com'
  end

  def notify_of_user_help_request(user, account_type)
    @user = user
    @account_type = account_type
    mail(from: help_request_recipient,  to: help_request_recipient, subject: 'User help request')
  end
end
