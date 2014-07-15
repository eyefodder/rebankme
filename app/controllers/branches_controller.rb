class BranchesController < EditableObjectController

  def initialize
    super
    @item_class = Branch
  end

  # def create
  #   @item = create_with_associations(:address)
  #   if @item.valid?
  #     after_successful_create
  #   else
  #     @item.address.destroy!
  #     @item.address = Address.new
  #     after_failed_create
  #   end
  # end





  private

  def item_params
    params.require(:branch).permit( :name, :bank_id, :street, :city, :state, :zipcode, :telephone, :hours)
  end

  def after_successful_create
    flash[:success] = "Successfully created a new Branch: #{@item.name}"
    redirect_to branches_path
  end

  def after_destroy
    redirect_to branches_path
  end
  def after_successful_update
    flash[:success] = "Item updated"
    redirect_to branches_path

  end

  # def set_new_item
  #   @item = @item_class.new
  #   @item.address = Address.new
  # end

end