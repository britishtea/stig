module Stig
  module Generators
    module Symbol
      extend self

      # Public: Generates a random Symbol. See Stig::Generators::String for 
      # usage
      #
      # Returns a Symbol.
      def random(*args)
        Generators::String.random(*args).to_sym
      end
    end
  end
end
