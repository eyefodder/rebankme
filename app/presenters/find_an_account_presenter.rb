class FindAnAccountPresenter < BasePresenter
  presents :account_type
  attr_accessor :user

  def act_token
    account_type.name_id
  end

  def intro_heading(options=nil)
    token = locale_token(:intro_heading)
    text = I18n.t(token, default: '')
    h.content_tag(:h3, text, options) unless text == ''
  end

  def intro_copy(options=nil)
    text = I18n.t(locale_token(:intro))
    h.content_tag(:div, text, options)
  end

  def cta_button(options=nil)
    h.link_to(I18n.t('account_finder.account_type.help_to_open_cta'), h.account_opening_assistance_path(user, account_type),options )
  end

  def option_heading(options=nil)
    interpolation_args = {default: '', zipcode: user.zipcode}
    text = I18n.t(locale_token(:option_heading), interpolation_args)
    h.content_tag(:h3, text, options) unless text == ''
  end

  def online_options

    I18n.t(locale_token(:online_options), default:{}).to_a.map{|obj| obj[1]}
  end

  def online_option_feature_bullets(bullets, list_options={}, bullet_options={})
    unless bullets.empty?
      bullets = bullets.to_a.map{|obj| obj[1]}
      h.content_tag(:ul,list_options) do
        res = ""
        bullets.each do |bullet|
          res << h.content_tag(:li, bullet, bullet_options )
        end
        res.html_safe
      end
    end
  end

  def google_map_search
    term = map_search_term
    unless term.nil?
      src = google_map_search_uri(term)
      h.render partial: 'account_finder/account_type/google_map', locals: {src: src}
    end
  end

  private

  def locale_token(element)
    "account_finder.account_type.#{act_token}.#{branching_element(element)}#{element}"
  end

  def branching_element(element)
    case account_type
    when AccountType.SENIORS_ACCOUNT
      user.state.us_bank_state? ? 'us_bank_states.' : 'non_us_bank_states.'
    when AccountType.VETERANS_ACCOUNT
      user.state.chase_state? ? 'chase_states.' : 'non_chase_states.'
    end

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
      user.state.us_bank_state? ? "USBank Branches near #{user.zipcode}" : "Credit Unions near #{user.zipcode}"
    when AccountType.VETERANS_ACCOUNT
      "Chase Branches near #{user.zipcode}" if user.state.chase_state?
    end
  end

end