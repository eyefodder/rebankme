# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
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