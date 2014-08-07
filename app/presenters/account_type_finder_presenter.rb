class AccountTypeFinderPresenter < BasePresenter
  presents :user



  def page_heading
    I18n.t("account_finder.#{next_property_token}.title")
  end

  alias_method :page_title, :page_heading


  def question_specific_form_content
    partial = next_property_token
    if h.lookup_context.template_exists?(partial, h.lookup_context.prefixes, true)
      h.render(partial: partial.to_s )
    end
  end

  def next_question_tag(options={})
    formatted_copy("account_finder.#{next_property_token}.question", options)
    # h.content_tag(:div, I18n.t("account_finder.#{next_property_token}.question"), options)
  end

  def next_question_bullets_tag(list_options={}, bullet_options={})
     render_localized_list("account_finder.#{next_property_token}.question_bullets", list_options, bullet_options)
  end

  def decision_buttons(options={})
    bullets = I18n.t("account_finder.#{next_property_token}.question_options", default:{}).to_a
    if bullets.empty?
      yes_button(options) + no_button(options)
    else
      res = ""
      bullets.each do |bullet|
        value = bullet[0]
        button_id = value==false ? 'next_question_no' : 'next_question_yes'
        defaults = { name: "option_submit[#{next_property_token}]", type: 'submit', value: value, id: button_id}
        icon = h.content_tag(:i, "", class: "glyphicon glyphicon-chevron-right color-white absolute full-height top right center-vert margin-less margin-right")
        text = h.content_tag(:div, bullet[1]);

        button = h.content_tag(:button, text + icon, defaults.merge(options) )
        res << button
      end
      res.html_safe
    end
  end


  def yes_button(options={})
    button_tag(:yes, true, options)
  end
  def no_button(options={})
    button_tag(:no, false, options)
  end



  private

  def next_property_token
    UserPropertyQuestionFactory.next_property_for(user)
  end

  def button_tag(action, value, options)
    defaults = { name: "user[#{next_property_token}]", type: 'submit', value: value, id: "next_question_#{action}"}
    button_options = defaults.merge(options)
    label = I18n.t("account_finder.#{next_property_token}.action_#{action}", default: I18n.t("forms.actions.action_#{action}"))
    h.content_tag(:button, label, button_options )
  end

end
