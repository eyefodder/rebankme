class AccountTypePresenter < BasePresenter
  presents :account_type

  def account_type_overview(options=nil)
    formatted_copy("#{account_type.name_id}.overview", options)
  end





  def find_right_account_link_for(user, options=nil)
    link_text = I18n.t("account_finder.account_type_found.cta", product: product_name)
    # link_path = user.email? ? h.account_finder_path(user) :  h.request_user_email_path(user,redirect_path: h.account_finder_path(user) )
    link_path = h.account_finder_path(user)
    h.link_to link_text , link_path, options
  end

  def page_heading
    I18n.t("account_finder.account_type_found.heading", product: product_name)
  end
    def page_subheading
    I18n.t("account_finder.account_type_found.sub_heading", product: product_name)
  end
      def page_title
    I18n.t("account_finder.account_type_found.page_title", product: product_name)
  end




  def why_account_type_chosen_for(user,list_options={}, bullet_options={})
    # list_options = {class:'default-class'}.merge(list_options) <-- if you want defaults
    reasons = account_type_choice_reasons_for user
    body = ""
    reasons.each do |reason|
      token = "deciding_factors.#{reason.values.first ? 'positive' : 'negative'}.#{reason.keys.first}"
      body = body + h.content_tag(:li, I18n.t(token), bullet_options)
    end
    h.content_tag(:ul, body.html_safe, list_options)
  end




  private





  def product_name
    I18n.t("#{account_type.name_id}.name")
  end

  def account_type_choice_reasons_for(user)
    case account_type
    when AccountType.PREPAY_CARD
      (user.has_predictable_income?) ? [{is_delinquent: true}] : [{is_delinquent: true}, {has_predictable_income: false}]
    when AccountType.SECOND_CHANCE
      [{is_delinquent: true}, {has_predictable_income: true}, {in_new_york_city: false}]
    when AccountType.SPECIAL_GROUP, AccountType.STUDENT_ACCOUNT, AccountType.VETERANS_ACCOUNT, AccountType.SENIORS_ACCOUNT
      [{is_delinquent: false}, {is_special_group: true}]
    when AccountType.REGULAR_ACCOUNT
      [{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: true}]
    when AccountType.CREDIT_UNION
      user.in_new_york_city? ? [{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: false}, {in_new_york_city: true}, {needs_debit_card: true}] : [{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: false}, {in_new_york_city: false}]
    when AccountType.SAFE_ACCOUNT
      user.is_delinquent ? [{is_delinquent: true}, {has_predictable_income: true}, {in_new_york_city: true}] : [{is_delinquent: false}, {is_special_group: false}, {will_use_direct_deposit: false}, {in_new_york_city: true}, {needs_debit_card: false}]
    end
  end

end