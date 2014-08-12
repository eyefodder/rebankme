# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class EmailSender
  def self.notify_of_user_help_request(user_id, account_type_id)
    UserMailer.notify_of_user_help_request(user_id, account_type_id).deliver
  end
end
