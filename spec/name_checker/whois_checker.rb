module NameChecker
  class WhoisChecker
    @service_name = :whois
    def self.check(host, options = {})
      # INFO: http://bit.ly/KYpzaj
      res = Whois.available?(host)
      Availability.new(@service_name, res)
    end
  end
end
