class BankAccountPresenter < BasePresenter
  presents :bank_account

  def distance_tag(user)
    distance = user.distance_to(bank_account.branch)
    h.content_tag(:span, h.number_to_human(distance, units: :miles), class: 'badge')
  end

  def name_tag
    h.content_tag(:span, "#{bank_account.name} (#{bank_account.branch.full_name})", class: 'editable-object-name')
  end
  def name_field_tag(form_builder)
    text_field_tag(form_builder, :name)
  end
  def branch_field_tag(form_builder)
    select_field_tag_with_options(form_builder, :branch, :full_name)
  end

  def account_type_field_tag(form_builder)
    select_field_tag_with_options(form_builder, :account_type)
  end

  private




end