class ApplicationController < ActionController::Base
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
