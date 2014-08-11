class BankAccountsController < EditableObjectController

  def initialize
    super
    @item_class = BankAccount

  end

  private
  def item_params
    params.require(:bank_account).permit( :name, :branch_id, :account_type_id)
  end
end