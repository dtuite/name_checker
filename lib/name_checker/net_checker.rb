module NameChecker
  class NetChecker
    def self.check(host_name, tld)
      RoboWhoisChecker.check("#{host_name}#{tld}")
    end
  end
end
