class BranchesController < EditableObjectController

  def initialize
    super
    @item_class = Branch
  end

  def create
    @item = create_with_associations(:address)
    if @item.valid?
      after_successful_create
    else
      @item.address.destroy!
      @item.address = Address.new
      after_failed_create
    end
  end



  def create_with_associations(association_sym)
    param_key = "#{association_sym.to_s}_attributes".to_sym
    obj_params = item_params
    associations_params = obj_params.delete(param_key)

    # child_class = sym.to_s.camelize.constantize

    new_obj = @item_class.new obj_params
    child_obj = new_obj.create_address(associations_params)
    new_obj.save
    new_obj

    # if new_obj.save



    # new_obj = @item_class.create obj_params
    # if new_obj.valid? && associations_params
    #   assoc_update_obj = {param_key => associations_params}
    #   unless new_obj.update_attributes(assoc_update_obj)
    #     new_obj.destroy
    #     new_obj = new_obj.dup
    #     new_obj.update_attributes(assoc_update_obj)
    #   end
    # end
    # new_obj
  end

  private

  def item_params
    params.require(:branch).permit( :name, :bank_id, {address_attributes: [:street, :city, :state, :zipcode]}, :telephone, :hours)
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

  def set_new_item
    @item = @item_class.new
    @item.address = Address.new
  end

end