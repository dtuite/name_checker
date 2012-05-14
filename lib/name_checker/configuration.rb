module NameChecker
  class Configuration
    attr_accessor :robowhois_key, :log_level

    def initialize
      self.robowhois_key = nil
      self.log_level = 'info'
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yeild(configuration) if block_given?
  end
end

# This can now be used under config/initializers/name_checker.rb
# NameChecker.configure do |config|
#   confg.robowhois_key = 'dfskljkf'
# end
