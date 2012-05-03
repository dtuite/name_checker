require "spec_helper"

describe NameChecker::Availability do
  describe "available?" do
    it "should return true if available" do
      availability = NameChecker::Availability.new('net', true)
      availability.should be_available
    end

    it "should return false otherwise" do
      availability = NameChecker::Availability.new('net', false)
      availability.should_not be_available
    end
  end

  describe "unavailable?" do
    it "should return true if unavailable" do
      availability = NameChecker::Availability.new('net', false)
      availability.should be_unavailable
    end

    it "should return false otherwise" do
      availability = NameChecker::Availability.new('net', true)
      availability.should_not be_unavailable
    end
  end

  describe "unknown?" do
    it "should return true if unknown" do
      availability = NameChecker::Availability.new('net', nil)
      availability.should be_unknown
    end

    it "should return false otherwise" do
      availability = NameChecker::Availability.new('net', true)
      availability.should_not be_unknown
    end
  end
end
