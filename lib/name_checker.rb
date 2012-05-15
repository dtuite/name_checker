require "name_checker/version"

require "httparty"
require "whois"
require "name_checker/logging"
require "name_checker/configuration"
require "name_checker/availability"
require "name_checker/twitter_checker"
require "name_checker/facebook_checker"
require "name_checker/robo_whois_checker"
require "name_checker/whois_checker"
require "name_checker/net_checker"

module NameChecker
  def self.check(text, service_name)
    # NOTE: Symbols are not good for detecting the service name.
    # Sometimes it might be 'co.uk'.
    case service_name
    when 'twitter' then TwitterChecker.check(text)
    when 'facebook' then FacebookChecker.check(text)
    # If not Twitter or Facebook then assume that the service
    # name is that of a TLD (like :com or :co.uk) and pass it to the
    # default net service checker.
    else NetChecker.check(text, service_name)
    end
  end
end
