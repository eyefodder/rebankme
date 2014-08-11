class BanksController < EditableObjectController

  def initialize
    super
    @item_class = Bank

  end

  private
  def item_params
    params.require(:bank).permit( :name)
  end



end
