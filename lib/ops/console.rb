module Ops
  module Console
    OPTIONS = { :bold => 1, :underline => 4 }

    COLORS = { :black => 30,
      :red =>  31, :green => 32, :yellow => 33, :blue => 34,
      :magenta => 35, :cyan => 36, :white => 37 }

    BG_COLORS = { :black => 40, :red =>  41, :green => 42,
      :yellow => 43, :blue => 44, :magenta => 45, :cyan => 46,
      :white => 47 }

    def self.reload!

    end

    def self.is_bash?
      `which bash`
      ( $? == 0 ) ? true : false
    end

    def self.bash_exec!( cmd )
      bash = `which bash`.strip
      `#{ bash } -c #{ cmd }"`
    end

    def print( string, opts = [] )
      c = []
      opts.each { | o | c << COLORS[ o ] if COLORS.has_key?( o ) }
      opts.each { | o | c << OPTIONS[ o ] if OPTIONS.has_key?( o ) }

      "\033[#{ c.join( ";" ) }m#{ string }\033[0m"
    end

    def random_color
      colors = COLORS.keys + BG_COLORS.keys
      colors.reject!{ | c | [ :white, :black ].include? c }
      colors.sample
    end
  end
end

class Color
  extend Ops::Console
end

class String
  extend Ops::Console

  def error
    replace Color.print( self , [ :bold, :red ] )
  end

  def warning
    replace Color.print( self , [ :bold, :yellow ] )
  end
end
