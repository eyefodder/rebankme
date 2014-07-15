class AddressesController < EditableObjectController

  def initialize
    super
    @item_class = Address
    # @item_class = Address
  end

  private

  def item_params
    params.require(:address).permit( :street, :city, :state, :zipcode)
  end

  def after_successful_create
    flash[:success] = "Successfully created a new Address: #{@item.full_address}"
    redirect_to addresses_path
  end

  def after_destroy
    redirect_to addresses_path
  end
  def after_successful_update
    flash[:success] = "Item updated"
    redirect_to addresses_path

  end

end
