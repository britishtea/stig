module Properties
  module Generators
    module Integer
      # Public: Generates a random Integer.
      #
      # max - A maximum Integer or Range (default: 100).
      #
      # Returns an Integer.
      def self.random(max = 100)
        rand(max)
      end
    end
  end
end
