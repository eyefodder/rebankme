class AccountTypePresenter < BasePresenter
  presents :account_type

  def best_veterans_account_title_for(user, options={})
    state_token = veteran_state_toke_for(user)
    h.content_tag(:h4, I18n.t("account_finder.account_type.veterans_account.#{state_token}.sub_heading"), options)
  end
    def best_veterans_account_explanation_for(user, options={})
    state_token = veteran_state_toke_for(user)
    h.content_tag(:div, I18n.t("account_finder.account_type.veterans_account.#{state_token}.explanation"), options)
  end
  def call_to_action_for_veterans(user, button_options={})
    if user.state.chase_state?
      src = google_map_search("Chase Branches near #{user.zipcode}")
      google_maps_iframe(src)
    else
      options = {target: '_blank'}.merge(button_options)
      h.link_to("Find out more at USAA's site",
                "https://www.usaa.com/inet/pages/bank_main?wa_ref=aff_amvets_banking",options)
    end
  end

  def find_right_account_link_for(user, options=nil)
    link_text = I18n.t("account_finder.account_type_found.cta", product: product_name)
    link_path = user.email? ? h.account_finder_path(user) :  h.request_user_email_path(user,redirect_path: h.account_finder_path(user) )
    h.link_to link_text , link_path, options
  end

  def page_heading

    I18n.t("account_finder.account_type_found.title", product: product_name)
  end

  def google_maps_tag_for_account_type_for_user(user)
    search_term = search_term_for_account_type(user)
    src = google_map_search(search_term)
    google_maps_iframe(src)
  end

  def google_maps_tag_for_account(account)
    google_maps_iframe(google_maps_src_for_account(account))
  end

  def google_maps_iframe(src)
    h.content_tag(:iframe, nil, width: 270, height: 270, frameborder: 0, style: 'border:0', src: src)
  end

  def google_maps_src_for_account(account)
    URI::encode("https://www.google.com/maps/embed/v1/place?key=#{ApiKeys.google_maps}&q=#{account.branch.bank.name}+#{account.branch.full_address}")
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

  alias_method :page_title, :page_heading


  private

  def google_map_search(search_term)
    URI::encode("https://www.google.com/maps/embed/v1/search?key=#{ApiKeys.google_maps}&q=#{search_term}")
  end

  def veteran_state_toke_for(user)
    user.state.chase_state? ? 'chase_states' : 'non_chase_states'
  end

  def search_term_for_account_type(user)
    case account_type
    when AccountType.CREDIT_UNION
      "Credit Unions near #{user.zipcode}"
    when AccountType.REGULAR_ACCOUNT
      "Free Checking near #{user.zipcode}"
    when AccountType.STUDENT_ACCOUNT
      "Free Student Checking near #{user.zipcode}"
    end
  end

  def product_name
    I18n.t("#{account_type.name_id}.name")
  end

  def account_type_choice_reasons_for(user)
    case account_type
    when AccountType.PREPAY_CARD
      [{is_delinquent: true}, {has_predictable_income: false}]
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
    else
      []
    end
  end

end