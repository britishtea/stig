require "date"

module Stig
  module Generators
    module Date
      extend self

      DEFAULT_INTERVAL = ::Date.new..::Date.today

      # Public: Generates a random Date.
      #
      # range - An interval Range (default: Date.new..Date.today).
      #
      # Returns a Date.
      def random(range = DEFAULT_INTERVAL)
        rand(range)
      end
    end
  end
end
