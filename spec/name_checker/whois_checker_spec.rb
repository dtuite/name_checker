require "spec_helper"

describe NameChecker::WhoisChecker do

  # NOTE: VCR can't catch Whois reqquests because they
  # are not HTTP requests.

  it "should tell if the domain is available" do
    availability = subject.check("dsjfdfjdjfd.com")
    availability.should be_available
    availability.service.should == 'whois'
  end

  it "should tell if the domain is unavailable" do
    availability = subject.check("apple.com")
    availability.should be_unavailable
  end

  it "should tell if the whois doesn't work" do
    Whois.stub(:available?) { nil }
    availability = subject.check("apple.com")
    availability.should be_unknown
  end
end
