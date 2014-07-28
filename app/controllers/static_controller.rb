class StaticController < ApplicationController
  require 'logging'

  def home
    log.debug {"home!"}
  end

	def index

  end
end
