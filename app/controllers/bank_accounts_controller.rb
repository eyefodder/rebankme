class BankAccountsController < EditableObjectController

  def initialize
    super
    @item_class = BankAccount

  end

  private
  def item_params
    params.require(:bank_account).permit( :name, :branch_id, :account_type_id)
  end

  def after_successful_create
    flash[:success] = "Successfully created a new Bank Account: #{@item.name}"
    redirect_to bank_accounts_path
  end

  def after_destroy
    redirect_to bank_accounts_path
  end
  def after_successful_update
    flash[:success] = "Item updated"
    redirect_to bank_accounts_path

  end

end