class AccountFinderController < ApplicationController
  def start
    # flash.now[:error] = "Could not save client"
    @user = User.new
  end

  def next
    @user  = User.new(user_params)
    if @user.valid?
      # figure out stuff
      puts @user.inspect
    else
      redirect_to :back, flash:{error: @user.errors.full_messages}
    end
  end
  private

  def user_params
    params.require(:user).permit(:zipcode,)
  end
end
