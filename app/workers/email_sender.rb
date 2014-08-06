class EmailSender

  def self.notify_of_user_help_request(user_id, account_type_id)
    UserMailer.notify_of_user_help_request(user_id, account_type_id).deliver
  end

end