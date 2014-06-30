class DemoController < ApplicationController
  def show_page
  	render "demo/#{params[:version]}/#{params[:page].gsub(/::/, '/')}"
  end
end
