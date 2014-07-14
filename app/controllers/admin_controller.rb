class AdminController < ApplicationController

  before_action :authenticate_admin_user!

  def home
    @admin = current_admin_user
  end


end
