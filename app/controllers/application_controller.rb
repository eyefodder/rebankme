# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class ApplicationController < ActionController::Base
   analytical
   use_vanity
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  attr_reader :log
  def initialize()
    super
    @log = Logging.logger[self]
    # @log.add_appenders(Logging.appenders.stdout, Logging.appenders.file('/app/log/development.log')) unless (@log.appenders.count > 0)
    @log.level = :debug
  end

end
