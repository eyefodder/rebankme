Logging.logger.root.add_appenders(Logging.appenders.stdout)
Logging.logger.root.add_appenders(Logging.appenders.file("/app/log/#{Rails.env}.log")) unless Rails.env.test?
Logging.logger.root.info {"\n\n\nSTARTING NEW LOGGING SESSION"}