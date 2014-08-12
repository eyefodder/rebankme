# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class UserPresenter < EditableObjectPresenter
  presents :user
  text_field_tags_for [:email]

  def skip_email_request(redirect_path, allow_skip = true, options = {})
    return if allow_skip == false
    options = { id: 'skip-email-request', class: 'underline' }.merge(options)
    h.link_to I18n.t('users.request_email.skip_email_request'),
              redirect_path,
              options
  end

  def what_you_need_bullets(list_options = {}, bullet_options = {})
    render_localized_list('users.help_me_open.what_you_need.things_needed',
                          list_options,
                          bullet_options)
  end

  def user_property_list
    res = ''
    user_properties.each do |property|
      res << h.content_tag(:li,
                           "#{property.to_s.humanize}: #{user[property]}")
    end
    res.html_safe
  end

  private

  def user_properties
    [:email,
     :zipcode,
     :is_delinquent,
     :is_special_group,
     :will_use_direct_deposit,
     :has_predictable_income,
     :needs_debit_card]
  end
end
