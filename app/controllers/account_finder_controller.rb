class AccountFinderController < ApplicationController
  def start
    @user = User.new
  end


  def next_type_question
    begin
      @user  = User.new(user_params)
      set_optional_values(@user,params)

      @account_type =  AccountTypeFactory.account_type_for(@user)

      if @account_type.nil?
        redirect_to :back, flash:{error: @user.errors.full_messages} unless @user.valid?
      else
        @user.save!
        render :account_type_found
      end
    rescue ActionController::ParameterMissing => e
      log.warn('user parameters missing; have to go back to start')
      redirect_to account_finder_start_path
    end



  end

  def find_account
    @user = User.find(params[:user_id])
    @account_type = AccountTypeFactory.account_type_for(@user)
    @results = BankAccount.accounts_near(@user, @account_type)
    if @results.count == 0
      @results = [BankAccount.where(account_type_id: @account_type.id).first]
    end
    template = "account_finder/account_type/#{@account_type.name_id}"
    render template
  end

  private

  def set_optional_values(user,params)
    if params[:option_submit]
      key = params[:option_submit].keys.first
      value = params[:option_submit].values.first
      if key == 'special_group'
        user.set_option(key, value)
      else
        user[key] = (value != 'false')
      end
    end
  end

  def user_params
    params.require(:user).permit(:zipcode,:is_delinquent, :has_predictable_income, :special_group_id, :will_use_direct_deposit, :needs_debit_card, :latitude, :longitude, :state_id)
  end


end
