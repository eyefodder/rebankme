# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class FindAnAccountPresenter < BasePresenter
  include GeolocatedResults
  presents :account_type
  attr_accessor :user
  attr_accessor :recommended_option
  attr_accessor :results
  attr_accessor :selected_result
  returns_localized_content [:sub_heading, :heading, :page_title]
  wraps_localized_content intro_heading: :h3,
                          intro: :div,
                          we_recommend_heading: :div,
                          why_chosen_heading: :h3,
                          why_chosen_description: :div,
                          geolocated_results_heading: :h4,
                          geolocated_results_subheading: :div,
                          recommended_available_at: :div,
                          option_heading: :h3,
                          option_subheading: :div

  def recommended_account_name(options = nil)
    h.content_tag(:h4, recommended_option.name, options)
  end

  def recommended_branch_address(options = nil)
    h.content_tag(:div, recommended_option.branch.full_address, options)
  end

  def recommended_branch_name(options = nil)
    h.content_tag(:div, recommended_option.branch.full_name, options)
  end

  ########## CONDITIONAL BLOCK RENDERING

  def recommended_option_block
    render_block_unless_nil(recommended_option, :recommended_option)
  end

  def why_recommended_block
    render_block_unless_nil(recommended_option, :why_recommended)
  end

  def geolocated_options_block
    render_block_unless_nil(results, :geolocated_options)
  end

  ########## MISC OTHER

  def cta_button(options = nil)
    h.link_to(I18n.t('account_finder.account_type.help_to_open_cta'),
              h.account_opening_assistance_path(user, account_type),
              options)
  end

  def online_options
    I18n.t(locale_token(:online_options), default: {}).to_a.map { |obj| obj[1] }
  end

  def online_option_feature_bullets(bullets,
                                    list_options = {},
                                    bullet_options = {})
    bullets = bullets.map { |obj| obj[1] }
    render_bullets(bullets, list_options, bullet_options)
  end

  private

  def interpolation_args
    args = { zipcode: user.zipcode,
             branch_name: '',
             branch_address: '',
             num_results: 0 }
    unless selected_result.nil?
      args.merge! branch_name: selected_result.branch.full_name,
                  branch_address: selected_result.branch.full_address
    end
    args.merge! num_results: results.count unless results.nil?
    args
  end

  def act_token
    account_type.name_id
  end

  def render_block_unless_nil(property, partial)
    return if property.nil?
    h.render(partial: "account_finder/account_type/#{partial}",
             locals: { presenter: self })
  end

  def locale_token(element)
    "account_finder.account_type.#{act_token}." \
    "#{branching_element(element)}#{element}"
  end

  def branching_element(element)
    return if [:page_title, :heading, :sub_heading].include? element
    case account_type
    when AccountType.SENIORS_ACCOUNT
      user.state.us_bank_state? ? 'us_bank_states.' : 'non_us_bank_states.'
    when AccountType.VETERANS_ACCOUNT
      user.state.chase_state? ? 'chase_states.' : 'non_chase_states.'
    end
  end
end
