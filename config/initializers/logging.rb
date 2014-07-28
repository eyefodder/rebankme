Logging.logger.root.add_appenders(Logging.appenders.stdout, Logging.appenders.file("/app/log/#{Rails.env}.log"))
Logging.logger.root.info {"\n\n\nSTARTING NEW LOGGING SESSION"}