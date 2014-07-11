class AccountTypePresenter < BasePresenter
  presents :account_type



  def page_heading
    product_name = I18n.t("#{account_type.name_id}.name")
    I18n.t("account_finder.account_type_found.title", product: product_name)
  end

  def account_type_overview
    heading = h.content_tag(:h3, I18n.t("account_finder.account_type_found.overview_heading"))
    content = h.content_tag(:div, I18n.t("#{account_type.name_id}.overview"))
    heading + content
  end

  def why_account_type_chosen_for(user)
    reasons = account_type_choice_reasons_for user

    heading = h.content_tag(:h3, I18n.t("account_finder.account_type_found.why_we_chose_heading"))
    body = ""
    reasons.each do |reason|
      token = "deciding_factors.#{reason.values.first ? 'positive' : 'negative'}.#{reason.keys.first}"
      body = body + h.content_tag(:li, I18n.t(token))
    end
    heading + h.content_tag(:ul, body.html_safe)
  end

  alias_method :page_title, :page_heading


  private

  def account_type_choice_reasons_for(user)
    case account_type
    when AccountType.PREPAY_CARD
      [{is_delinquent: true}, {has_predictable_income: false}]
    when AccountType.SECOND_CHANCE
      [{is_delinquent: true}, {has_predictable_income: true}, {in_new_york_city: false}]
    when AccountType.SPECIAL_GROUP
      [{is_delinquent: false}, {is_special_group: true}]
    when AccountType.REGULAR_ACCOUNT
      [{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: true}]
    when AccountType.CREDIT_UNION
      user.in_new_york_city? ? [{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: false}, {in_new_york_city: true}, {needs_debit_card: true}] : [{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: false}, {in_new_york_city: false}]
    when AccountType.SAFE_ACCOUNT
      user.is_delinquent ? [{is_delinquent: true}, {has_predictable_income: true}, {in_new_york_city: true}] : [{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: false}, {in_new_york_city: true}, {needs_debit_card: false}]
    else
      []
    end
  end

end