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
      @user.save!
      render :account_type_found
    end
  end

  def find_account
    @user = User.find(params[:user_id])
    @account_type = AccountTypeFactory.account_type_for(@user)
    @results = BankAccount.accounts_near(@user.zipcode, @account_type)
    if @results.count == 0
      @results = [BankAccount.where(account_type_id: @account_type.id).first]
    end
  end

  private

  def user_params
    params.require(:user).permit(:zipcode,:is_delinquent, :has_predictable_income, :is_special_group, :will_use_direct_deposit, :needs_debit_card, :latitude, :longitude)
  end
end
