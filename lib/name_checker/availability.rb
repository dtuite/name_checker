module NameChecker
  class Availability
    attr_reader :status, :service

    def initialize(service, status_input)
      @service = service
      @status = parse_status(status_input)
    end

    def to_s
      "#{service}: #{status}"
    end

    def available?
      status == "available"
    end

    def unavailable?
      status == "unavailable"
    end
    
    def unknown?
      status == "unknown"
    end

    def status=(status_input)
      @status ||= parse_status(status_input)
    end

    private 
      def parse_status(status_input)
        case status_input
        when true then "available"
        when false then "unavailable"
        else "unknown"
        end
      end
  end
end
