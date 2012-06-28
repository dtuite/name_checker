module NameChecker
  class FacebookChecker
    include HTTParty
    include Logging
    MIN_NAME_LENGTH = 5
    base_uri "https://graph.facebook.com"
    @service_name = :facebook

    def self.check(name, options = {})
      # just return false if the name is too short to be valid.
      if name.length < MIN_NAME_LENGTH
        return Availability.new(@service_name, false)
      end

      res = get("/#{name}")
    # So Facebook is bolloxed and sends back just the word 'false'
    # as the (invalid) json for certain queries. This causes a
    # MultiJson::DecodeError inside HTTParty which we need to catch.
    # INFO: http://stackoverflow.com/q/7357493/574190
    rescue MultiJson::DecodeError
      Availability.new(@service_name, false)
    else
      status = handle_response(res, name)
      Availability.new(@service_name, status)
    end

  private

    def self.log_warning(name, res)
      warning = "#{@service_name.upcase}_FAILURE: Handling #{name}. Response: #{res}"
      Logging.logger.warn(warning)
      # Nil return must be explicit because the logging will return true.
      return nil
    end

    def self.handle_response(res, name)
      case res.code
      when 200 then false
      when 404 then true
      else log_warning(name, res)
      end
    end
  end
end
