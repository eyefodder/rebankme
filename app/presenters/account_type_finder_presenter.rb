# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class AccountTypeFinderPresenter < BasePresenter
  presents :user

  def page_heading
    I18n.t("account_finder.#{next_property_token}.title")
  end

  alias_method :page_title, :page_heading

  def next_question_tag(options = {})
    formatted_copy("account_finder.#{next_property_token}.question", options)
  end

  def next_question_bullets_tag(list_options = {}, bullet_options = {})
    token = "account_finder.#{next_property_token}.question_bullets"
    render_localized_list(token, list_options, bullet_options)
  end

  def decision_buttons(options = {})
    bullets = I18n.t("account_finder.#{next_property_token}.question_options",
                     default: {}).to_a
    if bullets.empty?
      yes_button(options) + no_button(options)
    else
      decision_bullets(bullets, options)
    end
  end

  def decision_bullets(bullets, options)
    res = ''
    bullets.each do |bullet|
      value = bullet[0]
      text = h.content_tag(:div, bullet[1])
      button = h.content_tag(:button,
                             text + button_icon,
                             bullet_defaults(value).merge(options))
      res << button
    end
    res.html_safe
  end

  def yes_button(options = {})
    button_tag(:yes, true, options)
  end

  def no_button(options = {})
    button_tag(:no, false, options)
  end

  private

  def next_property_token
    UserPropertyQuestionFactory.next_property_for(user)
  end

  def button_tag(action, value, options)
    button_options = button_defaults(value, action).merge(options)
    h.content_tag(:button,
                  h.content_tag(:div, button_label(action)) + button_icon,
                  button_options)
  end

  def button_icon
    h.content_tag(:i, '', class: 'glyphicon glyphicon-chevron-right ' \
                                  'color-white absolute full-height top '\
                                  'right center-vert margin-less ' \
                                  'margin-right')
  end

  def button_label(action)
    I18n.t("account_finder.#{next_property_token}.action_#{action}",
           default: I18n.t("forms.actions.action_#{action}"))
  end

  def bullet_defaults(value)
    button_id = value == false ? 'next_question_no' : 'next_question_yes'
    { name: "option_submit[#{next_property_token}]",
      type: 'submit',
      value: value,
      id: button_id }
  end

  def button_defaults(value, action)
    { name: "user[#{next_property_token}]",
      type: 'submit',
      value: value,
      id: "next_question_#{action}" }
  end
end
