class AccountTypePresenter < BasePresenter
  presents :account_type



  def page_heading
    product_name = I18n.t("#{account_type.name_id}.name")
    I18n.t("account_finder.account_type_found.title", product: product_name)
  end

  def account_type_overview
    heading = h.content_tag(:h3, I18n.t("account_finder.account_type_found.overview_heading"))
    content = h.content_tag(:div, I18n.t("#{account_type.name_id}.overview"))
    heading + content
  end

  alias_method :page_title, :page_heading



end