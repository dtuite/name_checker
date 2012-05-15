require "name_checker/version"

require "httparty"
require "name_checker/logging"
require "name_checker/configuration"
require "name_checker/availability"
require "name_checker/twitter_checker"
require "name_checker/facebook_checker"
require "name_checker/robo_whois_checker"

module NameChecker
  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield(configuration)
  end
end
