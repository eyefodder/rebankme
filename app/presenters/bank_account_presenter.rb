class BankAccountPresenter < BasePresenter
  presents :bank_account

  def name_tag
    h.content_tag(:span, "#{bank_account.name} (#{bank_account.branch.full_name})", class: 'editable-object-name')
  end
  def name_field_tag(form_builder)
    text_field_tag(form_builder, :name)
  end
  def branch_field_tag(form_builder)
    branches = Branch.all.map {|branch| [branch.full_name, branch.id]}
    options = h.options_for_select(branches, selected: bank_account.branch_id)
    select_field_tag(form_builder, :branch_id, options)
  end

  def account_type_field_tag(form_builder)
    types = AccountType.all.map {|account_type| [account_type.name, account_type.id]}
    options = h.options_for_select(types, selected: bank_account.account_type_id)
    select_field_tag(form_builder, :account_type_id, options)
  end



end