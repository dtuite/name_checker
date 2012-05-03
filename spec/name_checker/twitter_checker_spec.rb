require "spec_helper"

# unless defined?(Rails)
#   class Rails; end
# end

describe NameChecker::TwitterChecker, "check" do
  # before { Rails.stub(logger: stub(:warn => true)) }

  it "should return positive the name is available" do
    VCR.use_cassette("available_twitter") do
      availability = NameChecker::TwitterChecker.check("sdfjksdh")
      availability.should be_available
    end
  end

  xit "should return negative if the name is too long" do
    VCR.use_cassette("long_name_twitter") do
      long_name = "sjkhdfkjsdhkjfhksjdfhkjsdsjhfkjhs"
      availability = NameChecker::TwitterChecker.check(long_name)
      availability.should be_unavailable
    end
  end

  xit "should return negtive if the name is taken" do
    VCR.use_cassette("unavailable_twitter") do
      availability = NameChecker::TwitterChecker.check("m")
      availability.should be_unavailable
    end
  end

  describe "rate limit handling" do
    xit "should log if the ratelimit-remaining if it is below 20" do
      VCR.use_cassette("ratelimit_remaining") do
        # Rails.logger.should_receive(:warn)
        NameChecker::TwitterChecker.check("m")
      end
    end

    xit "should not log if the ratelimit-remaining if it is above 20" do
      VCR.use_cassette("unavailable_twitter") do
        # Rails.logger.should_not_receive(:warn)
        NameChecker::TwitterChecker.check("m")
      end
    end
  end

  context "server returns 500 response" do
    let(:response) { stub(code: 500, headers: {}) }
    before { NameChecker::TwitterChecker.stub(:get) { response } }

    xit "should return unknown if there is an error" do
      availability = NameChecker::TwitterChecker.check("dsjfh")
      availability.should be_unknown
    end

    xit "should log the error if there is a server error" do
      # Rails.logger.should_receive(:warn)
      NameChecker::TwitterChecker.check("kdfj")
    end
  end

  context "user has been suspenved" do
    xit "should return negative" do
      VCR.use_cassette("suspended_twitter") do
        availability = NameChecker::TwitterChecker.check("apple")
        availability.should be_unavailable
      end
    end
  end
end
