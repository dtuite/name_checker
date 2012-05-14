# NOTE: This is rate limited to 150 requests per hour.
# TODO: Add OAuth or some other authentication in order
# to get my request limit rate increased.

module NameChecker
  class TwitterChecker
    include HTTParty
    include Logging
    MAX_NAME_LENGTH = 16
    base_uri "http://api.twitter.com"

    def self.check(screen_name, options = {})
      # Just return false if the suggestion exceeds the max allowed SN length.
      if screen_name.length > MAX_NAME_LENGTH
        return Availability.new(service_name, false)
      end

      # Carry on with the availability checking.
      options.merge!( query: { screen_name: screen_name } )
      res = get("/1/users/show.json", options)
      status = handle_response(res, screen_name)
      Availability.new(service_name, status)
    end

    def self.service_name
      'twitter'
    end

    def self.warning_limit
      20
    end

  private
    def self.handle_response(res, screen_name)
      log_rate_limit(res.headers["x-ratelimit-remaining"])

      # Twitter response codes:
      # INFO: https://dev.twitter.com/docs/error-codes-responses
      # 403 = Forbidden. Can be for a couple of reasons.
      case res.code
      when 200 then false
      when 403 then parse_403(screen_name, res)
      # Name is available if the request is not found
      when 404 then true
      else log_warning(screen_name, res)
      end
    end

    def self.log_warning(name, res)
      warning = "#{service_name.upcase}_FAILURE: Handling #{name}. Response: #{res}"
      Logging.logger.warn(warning)
      # Nil return must be explicit because the logging will return true.
      return nil
    end

    def self.log_rate_limit(remaining)
      return nil if remaining.to_i > warning_limit
      warning = "RATELIMIT_WARNING: Service #{service_name}. Remaining requests: #{remaining}"
      Logging.logger.warn(warning)
      # Nil return must be explicit because the logging will return true.
      return nil
    end

    def self.parse_403(name, res)
      return false if res["error"] =~ /suspended/
      # Something we hadn't intended happened if we reach this point
      log_warning(name, res)
    end
  end
end
