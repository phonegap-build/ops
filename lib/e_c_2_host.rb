class EC2Host < Host

  attr_reader :alias

  def initialize( host = 'unspecified', info = {}, opts = {} )
    super 
    @type = info[ "Type" ] || :ec2
  end
end
