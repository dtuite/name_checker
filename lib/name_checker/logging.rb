require "logger"

module Logging
  def logger
    Logging.logger
  end

  def self.logger(log_to = STDOUT)
    unless @logger
      @logger = Logger.new(log_to)
      @logger.level = Logging.infer_level
    end
    @logger
  end

  # infer a suitable Log level from the ENVIRONMENT variable
  # Can pass in an environment value for testing purposes
  def self.infer_level(level = nil)
    level = level || NameChecker.configuration.log_level
    case level
    when 'debug' then Logger::DEBUG
    when 'warn' then Logger::WARN
    else Logger::INFO # default
    end
  end
end
