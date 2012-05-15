module NameChecker
  class NetChecker
    def self.check(host_name, tld)
      host = host_name + tld

      # Use the RoboWhoisChecker if there is an API key set.
      if NameChecker.configuration.robo_whois_api_key
        RoboWhoisChecker.check(host)
      # Or use the WhoisChecker if there isn't (default).
      else
        WhoisChecker.check(host)
      end
    end
  end
end
