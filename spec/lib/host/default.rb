require 'spec_helper'

describe Host::Default do
  
  context "with tags" do

    before :each do
      @host = Host::Default.new
    end

    it "should allow you to add tags" do
      @host.tags = { "Platform" => "Windows" }
    end

    describe ".matches?" do

      before :each do
        @host.tags = { "Platform" => "Windows" }
      end

      it "should return true if all tags match" do
        @host.matches?( { "Platform" => "Windows" } ).should == true
      end

      it "should return true if all tags match" do
        @host.matches?( {
          "Platform" => "Windows",
          "Role" => "Worker" } ).should == false
      end
    end
  end
end
