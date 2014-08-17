# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class UsersController < ApplicationController
  def help_me_open
    @user = User.find(params[:user_id])
    @account_type = AccountType.find(params[:account_type_id])
    @redirect_path = account_opening_assistance_path(@user, @account_type)
    if @user.email?
      track! :shown_help_me_open
      EmailSender.delay.notify_of_help_request(@user.id, @account_type.id)
    else
      request_email_redirect(@user, @redirect_path, allow_skip: 0)
    end
  end

  def request_email
    @user = User.find(params[:user_id])
    @redirect_path = params[:redirect_path]
    @allow_skip = params[:allow_skip] != '0'
    track! :shown_request_email
  end

  def update
    set_item_from_params
    @redirect_path = URI.parse(params[:redirect_path]).path
    if @user.update_attributes(request_email_params)
      redirect_to @redirect_path, only_path: true
    else
      request_email_redirect(@user,
                             @redirect_path,
                             {},
                             error: @user.errors.full_messages)
    end
  end

  private

  def request_email_redirect(user, path, options = {}, flash = {})
    options = { redirect_path: path }.merge(options)
    redirect_to request_user_email_path(user, options), flash: flash
  end

  def set_item_from_params
    @user = User.find(params[:id])
  end

  def request_email_params
    params.require(:user).permit(:email)
  end
end
