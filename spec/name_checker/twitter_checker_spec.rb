require "spec_helper"

describe NameChecker::TwitterChecker, "check" do
  let(:fixtures_dir) { "twitter" }
  subject { NameChecker::TwitterChecker }

  def fixture_path(name)
    "#{fixtures_dir}/#{name}"
  end

  it "should return positive the name is available" do
    VCR.use_cassette(fixture_path("available")) do
      availability = subject.check("sdfjksdh")
      availability.should be_available
    end
  end

  it "should return negative if the name is too long" do
    VCR.use_cassette(fixture_path("long")) do
      long_name = "sjkhdfkjsdhkjfhksjdfhkjsdsjhfkjhs"
      availability = subject.check(long_name)
      availability.should be_unavailable
    end
  end

  it "should return negtive if the name is taken" do
    VCR.use_cassette(fixture_path("unavailable")) do
      availability = subject.check("m")
      availability.should be_unavailable
    end
  end

  describe "rate limit handling" do
    it "should log if the ratelimit-remaining if it is below 20" do
      VCR.use_cassette(fixture_path("rate_limit")) do
        Logging.logger.should_receive(:warn)
        subject.check("m")
      end
    end

    it "should not log if the ratelimit-remaining if it is above 20" do
      VCR.use_cassette(fixture_path("unavailable")) do
        Logging.logger.should_not_receive(:warn)
        subject.check("m")
      end
    end
  end

  context "server returns 500 response" do
    let(:response) { stub(code: 500, headers: {}) }
    before { subject.stub(:get) { response } }

    it "should return unknown if there is an error" do
      availability = subject.check("dsjfh")
      availability.should be_unknown
    end

    it "should log the error if there is a server error" do
      # Rails.logger.should_receive(:warn)
      subject.check("kdfj")
    end
  end

  context "user has been suspenved" do
    it "should return negative" do
      VCR.use_cassette(fixture_path("suspended")) do
        availability = subject.check("apple")
        availability.should be_unavailable
      end
    end
  end
end
