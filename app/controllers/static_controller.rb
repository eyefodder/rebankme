# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class StaticController < ApplicationController
  require 'logging'

  def home
    track! :shown_home_page
  end
end
