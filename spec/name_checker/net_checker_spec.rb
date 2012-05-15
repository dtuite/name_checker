require "spec_helper"

describe NameChecker::NetChecker do
  subject { NameChecker::NetChecker }

  describe "check" do
    it "should concat the host_name and tld" do
      host_name = "apple"
      tld = ".com"
      NameChecker::RoboWhoisChecker.should_receive(:check).with(host_name + tld)
      subject.check(host_name, tld)
    end
  end
end
