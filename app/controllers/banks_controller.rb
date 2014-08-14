# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class BanksController < EditableObjectController
  def initialize
    super
    @item_class = Bank
  end

  private

  def item_params
    params.require(:bank).permit(:name)
  end
end
