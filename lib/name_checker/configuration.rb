module NameChecker
  class Configuration
    attr_accessor :robo_whois_api_key, :log_level

    def initialize
      self.robo_whois_api_key = nil
      self.log_level = 'info'
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end
end

# This can now be used under config/initializers/name_checker.rb
# NameChecker.configure do |config|
#   config.robo_whois_api_key = 'dfskljkf'
# end
