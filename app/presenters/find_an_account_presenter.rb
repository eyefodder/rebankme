class FindAnAccountPresenter < BasePresenter
  presents :account_type
  attr_accessor :user
  attr_accessor :recommended_option
  attr_accessor :results
  attr_accessor :selected_result


  ### I18n strings

  def sub_heading
    I18n.t(locale_token(:sub_heading))
  end
  def heading
    I18n.t(locale_token(:heading))
  end
  def page_title
    I18n.t(locale_token(:page_title))
  end

  ##### LOCALIZED CONTENT UNLESS NIL METHODS

  def intro_heading(options=nil)
    content_unless_nil(:intro_heading,options)
  end

  def intro(options=nil)
    content_unless_nil(:intro, options, {}, :div)
  end

  def we_recommend_heading(options=nil)
    content_unless_nil(:we_recommend_heading, options)
  end

  def why_chosen_heading(options=nil)
    content_unless_nil(:why_chosen_heading, options)
  end

  def why_chosen_description(options=nil)
    content_unless_nil(:why_chosen_description, options, interpolation_args, :div)
  end

  def geolocated_results_heading(options=nil)
    content_unless_nil(:geolocated_results_heading, options,interpolation_args,:h4)
  end
  def geolocated_results_subheading(options=nil)
    content_unless_nil(:geolocated_results_subheading, options,interpolation_args,:div)
  end

  def recommended_available_at(options=nil)
    content_unless_nil(:recommended_available_at, options,interpolation_args,:div)
  end

  def option_heading(options=nil)
    content_unless_nil(:option_heading, options, interpolation_args)
  end

  def option_subheading(options=nil)
    content_unless_nil(:option_subheading, options, interpolation_args, :div)
  end



  ########## WRAPPED CONTENT METHODS

  def recommended_account_name(options=nil)
    h.content_tag(:h4, recommended_option.name, options)
  end

  def recommended_branch_address(options=nil)
    h.content_tag(:div, recommended_option.branch.full_address, options)
  end

  def recommended_branch_name(options=nil)
    h.content_tag(:div, recommended_option.branch.full_name, options)
  end

  ########## MAP RENDERING

  def geolocated_choice_map
    unless selected_result.nil?
      src = google_maps_src_for_account(selected_result)
      h.render partial: 'account_finder/account_type/google_map', locals: {src: src}
    end
  end

  def google_map_search
    term = map_search_term
    unless term.nil?
      src = google_map_search_uri(term)
      h.render partial: 'account_finder/account_type/google_map', locals: {src: src}
    end
  end


  ########## MISC OTHER

  def recommended_option_block
    unless recommended_option.nil?
      h.render(partial: 'account_finder/account_type/recommended_option', locals:{presenter: self})
    end
  end

  def cta_button(options=nil)
    h.link_to(I18n.t('account_finder.account_type.help_to_open_cta'), h.account_opening_assistance_path(user, account_type),options )
  end

  def geolocated_options_block
    unless results.nil?
      h.render partial: 'account_finder/account_type/geolocated_options', locals: {presenter: self}
    end
  end

  def geolocated_option_title(bank_account)
    bank_account.branch.full_name
  end

  def geolocated_option_street(bank_account)
    bank_account.branch.street
  end


  def geolocated_distance_from_user(bank_account,tag=:span, options=nil)
    distance = user.distance_to(bank_account.branch)
    h.content_tag(tag, h.number_to_human(distance, units: :miles),options)
  end

  def geolocated_result_link(bank_account,options=nil)
    link = h.account_finder_path(user, selected_account_id: bank_account.id )
    h.link_to(link, options) do
      yield
    end
  end

  def online_options
    I18n.t(locale_token(:online_options), default:{}).to_a.map{|obj| obj[1]}
  end


  def online_option_feature_bullets(bullets, list_options={}, bullet_options={})
    bullets = bullets.map{|obj| obj[1]}
    render_bullets(bullets, list_options, bullet_options)
  end



  ###########



































  private

  def interpolation_args
    args = {zipcode: user.zipcode, branch_name: '', branch_address: '', num_results: 0}
    unless selected_result.nil?
      args.merge! branch_name: selected_result.branch.full_name, branch_address: selected_result.branch.full_address
    end
    unless results.nil?
      args.merge! num_results: results.count
    end
    args
  end

  def act_token
    account_type.name_id
  end
  def content_unless_nil(property, options, interpolation_args={},tag=:h3)
    interpolation_args = {default: ''}.merge(interpolation_args)
    text = h.raw(I18n.t(locale_token(property), interpolation_args))
    h.content_tag(tag, text, options) unless text == ''
  end

  def locale_token(element)
    "account_finder.account_type.#{act_token}.#{branching_element(element)}#{element}"
  end

  def branching_element(element)
    unless [:page_title, :heading, :sub_heading].include? element
      case account_type
      when AccountType.SENIORS_ACCOUNT
        user.state.us_bank_state? ? 'us_bank_states.' : 'non_us_bank_states.'
      when AccountType.VETERANS_ACCOUNT
        user.state.chase_state? ? 'chase_states.' : 'non_chase_states.'
      end
    end

  end

  def google_maps_src_for_account(account)
    URI::encode("https://www.google.com/maps/embed/v1/place?key=#{ApiKeys.google_maps}&q=#{account.branch.bank.name}+#{account.branch.full_address}")
  end

  def google_map_search_uri(search_term)
    URI::encode("https://www.google.com/maps/embed/v1/search?key=#{ApiKeys.google_maps}&q=#{search_term}")
  end

  def map_search_term
    case account_type
    when AccountType.CREDIT_UNION
      "Credit Unions near #{user.zipcode}"
    when AccountType.REGULAR_ACCOUNT
      "Free Checking near #{user.zipcode}"
    when AccountType.STUDENT_ACCOUNT
      "Free Student Checking near #{user.zipcode}"
    when AccountType.SENIORS_ACCOUNT
      seniors_search_term
    when AccountType.VETERANS_ACCOUNT
      veterans_search_term
    end
  end

  def veterans_search_term
    "Chase Branches near #{user.zipcode}" if user.state.chase_state?
  end

  def seniors_search_term
    user.state.us_bank_state? ? "USBank Branches near #{user.zipcode}" : "Credit Unions near #{user.zipcode}"
  end

end