require "name_checker"
require 'vcr'

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.expand_path("../", __FILE__)
end

# A RoboWhois API Key must b supplied in order to regenerate VCR casettes. 
ROBO_WHOIS_API_KEY = "12345"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(SPEC_ROOT, "support/**/*.rb")].each { |f| require f }

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.ignore_hosts '127.0.0.1', 'localhost'

  if ROBO_WHOIS_API_KEY 
    c.filter_sensitive_data('<ROBO_WHOIS_API_KEY>') { ROBO_WHOIS_API_KEY }
  end
end

# Suppress warnings such as rate limit warnings when running specs.
Logging.logger(nil)

NameChecker.configure do |config|
  config.robo_whois_api_key = ROBO_WHOIS_API_KEY || 'ROBO_WHOIS_API_KEY'
end
