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
    h.content_tag(:div, I18n.t("account_finder.#{next_property_token}.question"), options)
  end

  def next_question_bullets_tag(list_options={}, bullet_options={})
    # list_options = {}.merge(list_options) <-- if you want defaults
    bullets = I18n.t("account_finder.#{next_property_token}.question_bullets", default:{}).to_a.map{|obj| obj[1]}
    unless bullets.empty?
      h.content_tag(:ul,list_options) do
        res = ""
        bullets.each do |bullet|
          res << h.content_tag(:li, bullet, bullet_options )
        end
        res.html_safe
      end
    end

  end

  def decision_buttons(options={})
    bullets = I18n.t("account_finder.#{next_property_token}.question_options", default:{}).to_a
    if bullets.empty?
      yes_button(options[:yes_no_button_options]) + no_button(options[:yes_no_button_options])
    else
      #optiosn button
      h.content_tag(:div, options[:grouped_container_options]) do
        res = ""
        bullets.each do |bullet|
          value = bullet[0]
          button_id = value==false ? 'next_question_no' : 'next_question_yes'
          defaults = { name: "option_submit[#{next_property_token}]", type: 'submit', value: value, id: button_id}
          button = h.content_tag(:button, bullet[1], defaults.merge(options[:grouped_item_options]) )
          # res << h.link_to(bullet[1], "#", options[:grouped_item_options] )
          res << button
          # res << h.content_tag(:li, bullet, options[:grouped_item_options] )
        end
        res.html_safe
      end
      # next_question_bullets_tag(options[:grouped_container_options], options[:grouped_item_options])
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