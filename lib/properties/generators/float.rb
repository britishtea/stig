module Properties
  module Generators
    module Float
      # Public: Generates a random Float.
      #
      # max - A maximum Float or Range.
      #
      # Returns a Float.
      def self.random(max = 0.0..1.0)
        rand(max)
      end
    end
  end
end
