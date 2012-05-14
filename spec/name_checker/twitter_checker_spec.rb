require "spec_helper"

describe NameChecker::TwitterChecker, "check" do
  it "should return positive the name is available" do
    VCR.use_cassette("available_twitter") do
      availability = klass.check("sdfjksdh")
      availability.should be_available
    end
  end

  it "should return negative if the name is too long" do
    VCR.use_cassette("long_name_twitter") do
      long_name = "sjkhdfkjsdhkjfhksjdfhkjsdsjhfkjhs"
      availability = klass.check(long_name)
      availability.should be_unavailable
    end
  end

  it "should return negtive if the name is taken" do
    VCR.use_cassette("unavailable_twitter") do
      availability = klass.check("m")
      availability.should be_unavailable
    end
  end

  describe "rate limit handling" do
    it "should log if the ratelimit-remaining if it is below 20" do
      VCR.use_cassette("ratelimit_remaining") do
        Logging.logger.should_receive(:warn)
        klass.check("m")
      end
    end

    it "should not log if the ratelimit-remaining if it is above 20" do
      VCR.use_cassette("unavailable_twitter") do
        Logging.logger.should_not_receive(:warn)
        klass.check("m")
      end
    end
  end

  context "server returns 500 response" do
    let(:response) { stub(code: 500, headers: {}) }
    before { klass.stub(:get) { response } }

    it "should return unknown if there is an error" do
      availability = klass.check("dsjfh")
      availability.should be_unknown
    end

    it "should log the error if there is a server error" do
      # Rails.logger.should_receive(:warn)
      klass.check("kdfj")
    end
  end

  context "user has been suspenved" do
    it "should return negative" do
      VCR.use_cassette("suspended_twitter") do
        availability = klass.check("apple")
        availability.should be_unavailable
      end
    end
  end
end
