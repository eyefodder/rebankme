# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class BankAccountPresenter < EditableObjectPresenter
  presents :bank_account

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

  def name_tag_contents
    "#{bank_account.name} (#{bank_account.branch.full_name})"
  end
end
