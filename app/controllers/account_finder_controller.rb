# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class AccountFinderController < ApplicationController
  def start
    @user = User.new
    track! :shown_start_page if flash[:error].nil?
  end

  def next_type_question
    @user  = User.new(user_params)
    set_optional_values(@user, params)
    @account_type =  AccountTypeFactory.account_type_for(@user)
    render_if_account_found
    redirect_if_invalid_user
    track_if_starting_account_finder
  rescue ActionController::ParameterMissing
    track! :errored_during_account_type_finder
    redirect_to account_finder_start_path
  end

  def find_account
    @user = User.find(params[:user_id])
    @account_type = AccountTypeFactory.account_type_for(@user)
    @results = BankAccount.accounts_near(@user, @account_type)
    if @results.count == 0
      @results = nil
    else
      set_recommended_and_selected_results
    end
    track! :shown_find_account
  end

  private

  def set_recommended_and_selected_results
    @recommended_result = @results.first
    s_id = params[:selected_account_id]
    @selected_result = s_id ? BankAccount.find(s_id) : @results.first
  end

  def track_if_starting_account_finder
    return if @user.answered_any_questions? || !@user.valid?
    track! :started_account_type_finder
  end

  def redirect_if_invalid_user
    return if @user.valid?
    redirect_to :back, flash: { error: @user.errors.full_messages }
  end

  def render_if_account_found
    return if @account_type.nil?
    @user.save!
    track! :shown_account_type
    render :account_type_found
  end

  def set_optional_values(user, params)
    return unless params[:option_submit]
    key = params[:option_submit].keys.first
    value = params[:option_submit].values.first
    if key == 'special_group'
      user.set_option(key, value)
    else
      user[key] = (value != 'false')
    end
  end

  def user_params
    params.require(:user).permit(:zipcode,
                                 :is_delinquent,
                                 :has_predictable_income,
                                 :special_group_id,
                                 :will_use_direct_deposit,
                                 :needs_debit_card,
                                 :latitude,
                                 :longitude,
                                 :state_id)
  end
end
