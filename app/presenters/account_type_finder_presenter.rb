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

  def decision_buttons
    # h.content_tag(:button, I18n.t('forms.actions.action_yes'), class: 'btn btn-info', name: "user[#{next_property_token}]", type: 'submit', value: true)
    button_tag(:yes, true) + button_tag(:no, false)
  end

  private

  def button_tag(action_label, value)
    h.content_tag(:button, I18n.t("forms.actions.action_#{action_label}"), class: 'btn btn-info', name: "user[#{next_property_token}]", type: 'submit', value: value)
  end

end