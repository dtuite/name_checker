require "spec_helper"

describe NameChecker::WhoisChecker do
  let(:fixtures_dir) { "whois" }
  subject { NameChecker::WhoisChecker }

  def fixture_path(name)
    "#{fixtures_dir}/#{name}"
  end

  it "should tell if the domain is available" do
    VCR.use_cassette(fixture_path('available')) do
      availability = subject.check("dsjfdfjdjfd.com")
      availability.should be_available
      availability.service.should == 'whois'
    end
  end

  it "should tell if the domain is unavailable" do
    VCR.use_cassette(fixture_path("unavailable")) do
      availability = subject.check("apple.com")
      availability.should be_unavailable
    end
  end

  it "should tell if the whois doesn't work" do
    Whois.stub(:available?) { nil }
    VCR.use_cassette(fixture_path("unknown")) do
      availability = subject.check("apple.com")
      availability.should be_unknown
    end
  end
end
