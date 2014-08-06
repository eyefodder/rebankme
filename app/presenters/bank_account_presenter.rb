class BankAccountPresenter < BasePresenter
  presents :bank_account



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