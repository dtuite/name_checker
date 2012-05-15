require "spec_helper"

describe NameChecker::RoboWhoisChecker, "check" do
  let(:fixtures_dir) { "robo_whois" }

  def fixture_path(name)
    "#{fixtures_dir}/#{name}"
  end

  it "should tell if the domain is unavailable" do
    VCR.use_cassette(fixture_path("unavailable")) do
      availability = NameChecker::RoboWhoisChecker.check("apple.com")
      availability.should be_unavailable
    end
  end

  it "should tell if the domain is available" do
    available_domain = "fwekjfkewfhwefhhfjcjksdjklka.com"
    VCR.use_cassette(fixture_path("available")) do
      availability = NameChecker::RoboWhoisChecker.check(available_domain)
      availability.should be_available
    end
  end

  it "should log if the remaining credits are below 50" do
    VCR.use_cassette(fixture_path("credits")) do
      Logging.logger.should_receive(:warn)
      availability = NameChecker::RoboWhoisChecker.check("apple.ly")
    end
  end

  it "should not log if the remaining credits are above 50" do
    VCR.use_cassette(fixture_path("unavailable")) do
      Logging.logger.should_not_receive(:warn)
      availability = NameChecker::RoboWhoisChecker.check("apple.com")
    end
  end

  # NOTE: These don't hit the network
  context "server returns non-200 status" do
    let(:host) { "apple.com" }
    let(:response) { stub(headers: {}, code: 500) }
    before { NameChecker::RoboWhoisChecker.stub(:get) { response } }

    it "should log" do
      Logging.logger.should_receive(:warn)
      NameChecker::RoboWhoisChecker.check(host)
    end

    it "should return 'unknown' availability" do
      availability = NameChecker::RoboWhoisChecker.check(host)
      availability.should be_unknown
    end
  end
end
