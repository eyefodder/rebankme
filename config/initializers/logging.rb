Logging.logger.root.add_appenders(Logging.appenders.stdout)
logfile = Logging.appenders.file(Rails.root.join('log', "#{Rails.env}.log"))
Logging.logger.root.add_appenders(logfile) if Rails.env.development?
