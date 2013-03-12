module Host

  class List < Array

    def filter( tags )
      self.select do | i |
        i.matches? tags 
      end
    end
  end
end
