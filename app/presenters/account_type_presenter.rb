# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class AccountTypePresenter < BasePresenter
  presents :account_type

  def account_type_overview(options = nil)
    formatted_copy("#{account_type.name_id}.overview", options)
  end

  def find_right_account_link_for(user, options = nil)
    link_text = I18n.t('account_finder.account_type_found.cta',
                       product: product_name)
    link_path = h.account_finder_path(user)
    h.link_to link_text, link_path, options
  end

  def page_heading
    I18n.t('account_finder.account_type_found.heading', product: product_name)
  end

  def page_subheading
    I18n.t('account_finder.account_type_found.sub_heading',
           product: product_name)
  end

  def page_title
    I18n.t('account_finder.account_type_found.page_title',
           product: product_name)
  end

  def why_account_type_chosen_for(user, list_options = {}, bullet_options = {})
    reasons = account_type_choice_reasons_for user
    body = ''
    reasons.each do |reason|
      body += h.content_tag(:li, I18n.t(reason_token(reason)), bullet_options)
    end
    h.content_tag(:ul, body.html_safe, list_options)
  end

  private

  def reason_token(reason)
    pos_neg = reason.values.first ? 'positive' : 'negative'
    "deciding_factors.#{pos_neg}.#{reason.keys.first}"
  end

  def product_name
    I18n.t("#{account_type.name_id}.name")
  end

  PREPAY_PREDICTABLE = [{ is_delinquent: true }]
  PREPAY_UNPREDICTABLE = [{ is_delinquent: true },
                          { has_predictable_income: false }]
  CREDIT_UNION_NYC = [{ is_delinquent: false },
                      { is_special_group: false },
                      { will_use_direct_deposit: false },
                      { in_new_york_city: true },
                      { needs_debit_card: true }]
  CREDIT_UNION_NON_NYC =  [{ is_delinquent: false },
                           { is_special_group: false },
                           { will_use_direct_deposit: false },
                           { in_new_york_city: false }]
  SAFE_ACCOUNT_DELINQUENT = [{ is_delinquent: true },
                             { has_predictable_income: true },
                             { in_new_york_city: true }]
  SAFE_ACCOUNT_NON_DELINQUENT = [{ is_delinquent: false },
                                 { is_special_group: false },
                                 { will_use_direct_deposit: false },
                                 { in_new_york_city: true },
                                 { needs_debit_card: false }]
  SECOND_CHANCE_REASONS = [{ is_delinquent: true },
                           { has_predictable_income: true },
                           { in_new_york_city: false }]
  SPECIAL_GROUP_REASONS = [{ is_delinquent: false }, { is_special_group: true }]
  REGULAR_ACCOUNT_REASONS = [{ is_delinquent: false },
                             { is_special_group: false },
                             { will_use_direct_deposit: true }]

  def account_type_choice_reasons_for(user)
    act = account_type
    return SPECIAL_GROUP_REASONS if act.special_group_account?
    return SECOND_CHANCE_REASONS if act == AccountType.SECOND_CHANCE
    return REGULAR_ACCOUNT_REASONS if act == AccountType.REGULAR_ACCOUNT
    return prepay_reasons(user) if act == AccountType.PREPAY_CARD
    return credit_union_reasons(user) if act == AccountType.CREDIT_UNION
    return safe_account_reasons(user) if act == AccountType.SAFE_ACCOUNT
  end

  def prepay_reasons(user)
    (user.has_predictable_income?) ? PREPAY_PREDICTABLE : PREPAY_UNPREDICTABLE
  end

  def credit_union_reasons(user)
    user.in_new_york_city? ?  CREDIT_UNION_NYC : CREDIT_UNION_NON_NYC
  end

  def safe_account_reasons(user)
    user.is_delinquent ? SAFE_ACCOUNT_DELINQUENT : SAFE_ACCOUNT_NON_DELINQUENT
  end
end
