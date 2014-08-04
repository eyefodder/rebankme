class FindAnAccountPresenter < BasePresenter
  presents :account_type
  attr_accessor :user

  def sub_heading(options=nil)
    text = I18n.t("account_finder.account_type.prepay_card.sub_heading")
    h.content_tag(:h3, text, options)
  end

  def intro_copy(options=nil)
    text = I18n.t("account_finder.account_type.prepay_card.intro")
    h.content_tag(:div, text, options)
  end

  def cta_button(options=nil)
    h.link_to(I18n.t('account_finder.account_type.help_to_open_cta'), h.demo_path('holding_content', 'prepare_to_open'), options)
  end

end