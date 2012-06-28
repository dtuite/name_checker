require "spec_helper"

describe NameChecker::FacebookChecker, "check" do
  let(:fixtures_dir) { "facebook" }
  subject { NameChecker::FacebookChecker }

  def fixture_path(name)
    "#{fixtures_dir}/#{name}"
  end

  it "should return negative if the name is too short" do
    VCR.use_cassette(fixture_path("short")) do
      availability = subject.check("jsda")
      availability.should be_unavailable
      availability.service.should == "facebook"
    end
  end

  it "should return negative if facebook returns 'false'" do
    VCR.use_cassette(fixture_path("false")) do
      availability = subject.check("thirdone")
      availability.should be_unavailable
      availability.service.should == "facebook"
    end
  end

  it "should return positive the name is available" do
    VCR.use_cassette(fixture_path("available")) do
      availability = subject.check("sdfjksdh")
      availability.should be_available
    end
  end

  it "should return negtive if the name is taken" do
    VCR.use_cassette(fixture_path("unavailable")) do
      availability = subject.check("davidtuite")
      availability.should be_unavailable
    end
  end

  it "should non choke on weird chars" do
    VCR.use_cassette(fixture_path("weird_chars")) do
      availability = subject.check("rememberly")
      availability.should be_unavailable
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
      Logging.logger.should_receive(:warn)
      subject.check("kdfjss")
    end
  end
end
