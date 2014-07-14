class BankPresenter < BasePresenter
  presents :bank

  def name_tag
    h.content_tag(:span, bank.name, class: 'editable-object-name')
  end


end