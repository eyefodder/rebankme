class BranchPresenter < BasePresenter
  presents :branch

  def bank_field_tag(form_builder)
    label = form_builder.label(:bank_id, 'Bank')
    banks = Bank.all.map {|bank| [bank.name, bank.id]}

    field = form_builder.select(:bank_id, h.options_for_select(banks, selected: branch.bank_id))
    label + field
  end

  def name_field_tag(form_builder)
    text_field_tag(form_builder, :name)
  end
  def telephone_field_tag(form_builder)
    text_field_tag(form_builder, :telephone)
  end
  def hours_field_tag(form_builder)
    text_field_tag(form_builder, :hours)
  end
  def address_field_tag(form_builder)
    text_field_tag(form_builder, :address_id)
  end

  def name_tag
    h.content_tag(:span, "#{@object.name} (#{branch.address.full_address})", class: 'editable-object-name')
  end

  private

  def text_field_tag(form_builder, id)
    label = form_builder.label(id)
    field = form_builder.text_field(id)
    label + field
  end

end