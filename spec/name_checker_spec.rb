require "spec_helper"

describe NameChecker do
  describe "check" do
    let(:text) { "hello" }
    subject { NameChecker }

    it "should check the twitter service" do
      NameChecker::TwitterChecker.should_receive(:check).with(text)
      subject.check(text, 'twitter')
    end

    it "shoud check the facebook service" do
      NameChecker::FacebookChecker.should_receive(:check).with(text)
      subject.check(text, 'facebook')
    end

    it "shoud check the robo whois service" do
      service_name = 'com'
      NameChecker::NetChecker.should_receive(:check).with(text, service_name)
      subject.check(text, service_name)
    end
  end
end
