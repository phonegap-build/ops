module Host
  class EC2 < Host::Default

    attr_reader :alias

    def initialize( host = 'unspecified', info = {}, opts = {} )
      super 
      @type = info[ "Type" ] || :ec2
    end
  end
end
