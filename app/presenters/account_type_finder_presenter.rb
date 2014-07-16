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

  def next_question_tag
    h.content_tag(:div, I18n.t("account_finder.#{next_property_token}.question"), class: 'account-finder-question')
  end

  def next_question_bullets_tag
    bullets = I18n.t("account_finder.#{next_property_token}.question_bullets", default:{}).to_a.map{|obj| obj[1]}
    # puts "bullets: #{bullets}"
    unless bullets.empty?
      h.content_tag(:ul, class: 'list-group section') do
        res = ""
        bullets.each do |bullet|
          res << h.content_tag(:li, bullet, class: 'list-group-item')
        end
        res.html_safe
      end
    end

  end

  def decision_buttons

    # h.content_tag(:button, I18n.t('forms.actions.action_yes'), class: 'btn btn-info', name: "user[#{next_property_token}]", type: 'submit', value: true)
    yes_button = button_tag(:yes, true)
    no_button = button_tag(:no, false)
    h.content_tag(:div, class: 'row') do
      # h.content_tag(:div, yes_button, class: 'col-xs-6') + h.content_tag(:div, no_button, class: 'col-xs-6')
      h.content_tag(:div, class: 'col-xs-12') do

        yes_button + no_button
      end
    end

  end



  private

  def button_tag(action, value)
    label = I18n.t("account_finder.#{next_property_token}.action_#{action}", default: I18n.t("forms.actions.action_#{action}"))
    h.content_tag(:button, label, class: 'btn btn-info btn-block', name: "user[#{next_property_token}]", type: 'submit', value: value, id: "next_question_#{action}" )
  end

end