require 'spec_helper'

describe Host::List do

  before :each do
    @list = Host::List.new
  end

  it "should be an extenstion of the array class" do
    @list.kind_of?( Array ).should == true
  end

  describe ".filter" do

    before :each do
      @host = Host::Default.new( "host1" )
      @host.tags = { "Platform" => "Windows" }
      @list << @host
    end
    
    it "should iterate through the items and call .matches?" do
      @host.should_receive( :matches? )
      @list.filter( { "Platform" => "Windows" } )
    end

    it "should return the matched host" do
      hosts = @list.filter( { "Platform" => "Windows" } )
      hosts.length.should == 1
    end

    it "should return a empty list" do
      hosts = @list.filter( { "Platform" => "Linux" } )
      hosts.length.should == 0
    end
  end
end
