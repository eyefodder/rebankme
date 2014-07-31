Logging.logger.root.add_appenders(Logging.appenders.stdout)
Logging.logger.root.add_appenders(Logging.appenders.file(Rails.root.join('log', "#{Rails.env}.log"))) if Rails.env.development?
Logging.logger.root.info {"\n\n\nSTARTING NEW LOGGING SESSION"}