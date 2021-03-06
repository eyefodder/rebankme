# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class EditableObjectController < ApplicationController
  before_action :authenticate_admin_user!

  def initialize
    super
  end

  def index
    @items = @item_class.all
  end

  def new
    set_new_item
  end

  def create
    @item = @item_class.new(item_params)
    if @item.save
      after_successful_create
    else
      after_failed_create
    end
  end

  def edit
    set_item_from_params
  end
  # def show
  #   set_item_from_params
  # end

  def destroy
    @item_class.find(params[:id]).destroy
    after_destroy
  end

  def update
    set_item_from_params
    if @item.update_attributes(item_params)
      after_successful_update
    else
      after_failed_update
    end
  end

  private

  # def create_with_associations(association_sym)
  #   param_key = "#{association_sym.to_s}_attributes".to_sym
  #   obj_params = item_params
  #   associations_params = obj_params.delete(param_key)
  #   new_obj = @item_class.new obj_params
  #   child_obj = new_obj.create_address(associations_params)
  #   new_obj.save
  #   new_obj
  # end

  def set_new_item
    @item = @item_class.new
  end

  def set_item_from_params
    @item = @item_class.find(params[:id])
  end

  def after_successful_create
    flash[:success] = 'Successfully created a new ' \
                      "#{@item_class.model_name.human}: #{@item.name}"
    after_success
  end

  def after_successful_update
    flash[:success] = 'Item updated'
    after_success
  end

  def after_destroy
    flash[:success] = 'Item deleted'
    after_success
  end

  def after_success
    redirect_to polymorphic_path(@item_class)
  end

  def after_failed_create
    render 'new'
  end

  def after_failed_update
    render 'edit'
  end
end
