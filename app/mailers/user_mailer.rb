class UserMailer < ActionMailer::Base


  @@rebank_recipient
  default from: ActionMailer::Base.smtp_settings[:user_name]

  def cc_recipient
     ActionMailer::Base.smtp_settings[:user_name]
  end

  def help_request_recipient
    @@rebank_recipient ||= ENV['MAILER_REBANK_RECIPIENT']
    @@rebank_recipient ||= 'test@example.com'
  end



  def notify_of_user_help_request(user, account_type)
    @user = user
    @account_type = account_type
    mail( to: help_request_recipient, cc: cc_recipient,  subject: "#{account_type.name} help request from #{user.email}")
  end
end
