class AccountTypePresenter < BasePresenter
  presents :account_type



  def page_heading
    product_name = I18n.t("#{account_type.name_id}.name")
    I18n.t("account_finder.account_type_found.title", product: product_name)
  end

  alias_method :page_title, :page_heading



end