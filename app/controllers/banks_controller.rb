class BanksController < EditableObjectController

  def initialize
    super
    @item_class = Bank

  end

  private
  def item_params
    params.require(:bank).permit( :name)
  end

  def after_successful_create
    flash[:success] = "Successfully created a new Bank: #{@item.name}"
    redirect_to banks_path
  end

  def after_destroy
    redirect_to banks_path
  end
  def after_successful_update
    flash[:success] = "Item updated"
    redirect_to banks_path

  end

end
