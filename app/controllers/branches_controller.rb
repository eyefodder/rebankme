# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class BranchesController < EditableObjectController
  def initialize
    super
    @item_class = Branch
  end

  private

  def item_params
    params.require(:branch).permit(:name,
                                   :bank_id,
                                   :street,
                                   :city,
                                   :state,
                                   :zipcode,
                                   :telephone,
                                   :hours)
  end
end
