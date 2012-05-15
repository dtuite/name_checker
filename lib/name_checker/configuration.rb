# Enable setting and getting of configuration options.
#
# Example:
#
#   This can now be used under config/initializers/name_checker.rb
#   NameChecker.configure do |config|
#     config.robo_whois_api_key = 'dfskljkf'
#   end

module NameChecker
  class Configuration
    DEFAULT_LOG_LEVEL = 'info'
    DEFAULT_ROBO_WHOIS_API_KEY = nil

    attr_accessor :robo_whois_api_key, :log_level

    def initialize
      self.log_level = DEFAULT_LOG_LEVEL
      self.robo_whois_api_key = DEFAULT_ROBO_WHOIS_API_KEY
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end
end
