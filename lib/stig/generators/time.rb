module Stig
  module Generators
    module Time
      extend self

      DEFAULT_INTERVAL = ::Time.at(0)..::Time.now

      # Public: Generates a random Time.
      #
      # interval - An interval Range (default: Time.at(0)..Time.now).
      #
      # Returns a Time.
      def random(interval = DEFAULT_INTERVAL)
        unix_time = rand(interval.min.to_i..interval.max.to_i)
        
        ::Time.at(unix_time)
      end
    end
  end
end
