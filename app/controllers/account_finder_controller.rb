class AccountFinderController < ApplicationController
  def start
    @user = User.new
  end


  def next_type_question
    @user  = User.new(user_params)
    @account_type =  AccountTypeFactory.account_type_for(@user)
    if @account_type.nil?
      redirect_to :back, flash:{error: @user.errors.full_messages} unless @user.valid?
    else
      render :account_type_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:zipcode,:is_delinquent, :has_predictable_income)
  end
end
