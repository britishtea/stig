module Properties
  module Generators
    module Character
      ASCII     = 0.upto(127).to_a
      PRINTABLE = 32.upto(126).to_a
      DIGITS    = 48.upto(57).to_a
      UPPERCASE = 65.upto(90).to_a
      LOWERCASE = 97.upto(122).to_a
      ALPHABET  = UPPERCASE + LOWERCASE

      # Public: Generates a random character.
      #
      # set - An Array of objects that respond to #chr (default: ASCII).
      #
      # Returns a 1 character String.
      # Raises ArgumentError when `set` contains objects not responding to #chr.
      # Raises ArgumentError when `set` is empty.
      def self.random(set = ASCII)
        unless set.all? { |object| object.respond_to?(:chr) }
          raise ArgumentError, "set contains objects not responding to #chr"
        end

        if set.empty?
          raise ArgumentError, "set is empty"
        end

        set = set.map(&:chr).sample
      end
    end
  end
end
