module Properties
  module Generators
    module Character
      ASCII     = 0.upto(127).map(&:chr)
      PRINTABLE = 32.upto(126).map(&:chr)
      DIGITS    = 48.upto(57).map(&:chr)
      UPPERCASE = 65.upto(90).map(&:chr)
      LOWERCASE = 97.upto(122).map(&:chr)
      ALPHABET  = UPPERCASE + LOWERCASE

      # Public: Generates a random character.
      #
      # set - An Array of one character Strings.
      #
      # Returns a 1 character String.
      # Raises ArgumentError when `set` is empty.
      def self.random(set = ASCII)
        if set.empty?
          raise ArgumentError, "character set is empty"
        end

        set = set.sample
      end
    end
  end
end
