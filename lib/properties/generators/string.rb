module Properties
  module Generators
    module String
      # Public: Generates a random String.
      #
      # set  - An Array of one character Strings (default: ASCII).
      # size - A maximum length Integer or Range (default: 25).
      #
      # Returns a String.
      def self.random(set = Character::ASCII, size = 25)
        if set.empty?
          raise ArgumentError, "character set is empty"
        end
        
        result = ""
        
        rand(size).times do
          result << set.sample
        end

        result
      end
    end
  end
end
