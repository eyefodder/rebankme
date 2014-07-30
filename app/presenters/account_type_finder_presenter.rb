class AccountTypeFinderPresenter < BasePresenter
  presents :user

  def next_property_token
    if user.is_delinquent
      :has_predictable_income
    elsif user.is_delinquent == false
      if user.is_special_group == false
        if user.will_use_direct_deposit == false
          :needs_debit_card
        else
          :will_use_direct_deposit
        end
      else
        :is_special_group
      end
    else
      :is_delinquent
    end
  end

  def page_heading
    I18n.t("account_finder.#{next_property_token}.title")
  end

  alias_method :page_title, :page_heading

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



  def yes_button(options={})
    button_tag(:yes, true, options)
  end
  def no_button(options={})
    button_tag(:no, false, options)
  end



  private


  def button_tag(action, value, options)
    defaults = { name: "user[#{next_property_token}]", type: 'submit', value: value, id: "next_question_#{action}"}
    button_options = defaults.merge(options)
    label = I18n.t("account_finder.#{next_property_token}.action_#{action}", default: I18n.t("forms.actions.action_#{action}"))
    h.content_tag(:button, label, button_options )
  end

end