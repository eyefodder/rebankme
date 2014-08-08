class StaticController < ApplicationController
  require 'logging'

  def home

    track! :shown_home_page
  end


end
