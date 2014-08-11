class UsersController < ApplicationController


  def help_me_open
    @user = User.find(params[:user_id])
    @account_type = AccountType.find(params[:account_type_id])
    @redirect_path = account_opening_assistance_path(@user, @account_type)
    if @user.email?
      track! :shown_help_me_open
      EmailSender.delay.notify_of_user_help_request(@user.id, @account_type.id)
    else
      redirect_to request_user_email_path(@user, redirect_path: @redirect_path, allow_skip: 0)
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
    @redirect_path = params[:redirect_path]
    if @user.update_attributes(request_email_params)
      redirect_to @redirect_path, only_path: true
    else

      redirect_to request_user_email_path(@user, redirect_path: @redirect_path), flash:{error: @user.errors.full_messages}
    end
  end

  private

  def set_item_from_params
    @user = User.find(params[:id])
  end

  def request_email_params
    params.require(:user).permit( :email)
  end

end
