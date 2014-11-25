module Stig
  module Generators
    module Integer
      extend self

      # Public: Generates a random Integer.
      #
      # max - A maximum Integer or Range (default: 100).
      #
      # Returns an Integer.
      def random(max = 100)
        rand(max)
      end
    end
  end
end
