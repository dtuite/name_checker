require "spec_helper"

describe NameChecker::NetChecker do
  subject { NameChecker::NetChecker }

  describe "check" do
    let(:host_name) { "apple" }
    let(:tld) { ".com" }

    it "should hit the RoboWhoisChecker if there is an api key" do
      NameChecker.configuration.stub(:robo_whois_api_key) { "123" }

      NameChecker::RoboWhoisChecker.should_receive(:check)
        .with(host_name + tld)
      subject.check(host_name, tld)
    end

    it "should hit the WhoisChecker if there is no api key" do
      NameChecker.configuration.stub(:robo_whois_api_key) { nil }

      NameChecker::WhoisChecker.should_receive(:check)
        .with(host_name + tld)
      subject.check(host_name, tld)
    end
  end
end
