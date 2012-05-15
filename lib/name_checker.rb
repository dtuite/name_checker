require "name_checker/version"

require "httparty"
require "name_checker/logging"
require "name_checker/configuration"
require "name_checker/availability"
require "name_checker/twitter_checker"
require "name_checker/facebook_checker"
require "name_checker/robo_whois_checker"

module NameChecker
  def self.check(text, service_name)
    case service_name.to_sym
    when :twitter then TwitterChecker.check(text)
    when :facebook then FacebookChecker.check(text)
    when :robo_whois then RoboWhoisChecker.check(text)
    end
  end
end
