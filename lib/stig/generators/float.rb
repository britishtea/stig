module Stig
  module Generators
    module Float
      extend self
      
      # Public: Generates a random Float.
      #
      # max - A maximum Float or Range (default 0.0..1.0).
      #
      # Returns a Float.
      def random(max = 0.0..1.0)
        rand(max)
      end
    end
  end
end
