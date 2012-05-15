module NameChecker
  class NoAPIKeyError < ArgumentError; end

  class RoboWhoisChecker
    include HTTParty
    include Logging
    base_uri 'http://api.robowhois.com'
    @service_name = :robo_whois

    def self.check(host, options={})
      options.merge!(basic_auth: auth_options)

      # NOTE: RoboWhois will return 404 if I append ".json".
      res = get("/whois/#{host}/availability", options)
      status = handle_response(res, host)
      Availability.new(@service_name.to_s, status)
    end

    # NOTE: We can't use the 'basic_auth' method because the
    # configuration object is not available at the class level.
    def self.auth_options
      # raise NoAPIKeyError unless NameChecker.configuration.robo_whois_api_key

      { password: 'X',
        username: NameChecker.configuration.robo_whois_api_key }
    end

    def self.warning_limit
      50
    end

  private
    def self.log_warning(name, res)
      warning = "#{@service_name.upcase}_FAILURE: Handling #{name}. Response: #{res}"
      Logging.logger.warn(warning)
      # Nil return must be explicit because the logging will return true.
      return nil
    end

    def self.handle_response(res, host)
      log_remaining_credits(res.headers["X-Creditlimit-Remaining"])
      case res.code
      when 200 then res["response"]["available"]
      else log_warning(host, res)
      end
    end

    def self.log_remaining_credits(remaining_count)
      # INFO: Some responses might not have the header available.
      unless remaining_count and remaining_count.to_i < warning_limit
        return nil
      end

      warning = "RATELIMIT_WARNING: Service #{@service_name}. 
Remaining credits: #{remaining_count}"
      Logging.logger.warn(warning)
      # Nil return must be explicit because the logging will return true.
      return nil
    end
  end
end
