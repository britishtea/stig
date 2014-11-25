require "stig/generators/character"

module Stig
  module Generators
    module String
      extend self

      # Public: Generates a random String. Characters are picked from a 
      # character set (`set`). Size is variable, use a Range with equal start
      # and end for a fixed size.
      #
      # set  - An Array of one character Strings (default: ASCII).
      # size - A maximum length Integer or Range (default: 25).
      #
      # Returns a String.
      def random(set = Character::ASCII, size = 25)
        result = ""
        
        rand(size).times do
          char = set.sample || raise(ArgumentError, "character set is empty")
          result << char
        end

        result
      end
    end
  end
end
