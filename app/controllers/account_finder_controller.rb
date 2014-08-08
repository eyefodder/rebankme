class AccountFinderController < ApplicationController
  def start
    @user = User.new
    track! :shown_start_page if flash[:error].nil?
  end




  def next_type_question
    begin
      @user  = User.new(user_params)
      set_optional_values(@user,params)

      @account_type =  AccountTypeFactory.account_type_for(@user)

      if @account_type.nil?
        redirect_to :back, flash:{error: @user.errors.full_messages} unless @user.valid?
        track! :started_account_type_finder unless @user.answered_any_questions?
      else
        @user.save!
        track! :shown_account_type
        render :account_type_found
      end
    rescue ActionController::ParameterMissing => e
      log.warn('user parameters missing; have to go back to start')
      track! :errored_during_account_type_finder
      redirect_to account_finder_start_path
    end
  end

  def find_account
    @user = User.find(params[:user_id])
    @account_type = AccountTypeFactory.account_type_for(@user)
    @results = BankAccount.accounts_near(@user, @account_type)

    if @results.count == 0
      @results = nil
    else
      @recommended_result = @results.first

      @selected_result = params[:selected_account_id] ? BankAccount.find(params[:selected_account_id]) : @results.first # unless param passed
    end
    track! :shown_find_account
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
