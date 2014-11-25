module Stig
  module Generators
    module Hash
      extend self

      # Public: Generates a random Hash. If no keys are passed, a Hash with a
      # default proc is returned.
      #
      # generator - An Enumerator or an object implementing #random.
      # keys      - Objects to use as Hash keys.
      #
      # Returns a Hash.
      # Raises ArgumentError when an invalid generator was supplied.
      def random(generator, *keys)
        unless generator.is_a?(Enumerator) || generator.respond_to?(:random)
          raise ArgumentError, "no #random implemented for #{generator}"
        end

        method = generator.is_a?(Enumerator) ? :next : :random

        if keys.empty?
          hash = ::Hash.new { |hash, key| hash[key] = generator.send(method) }
        else
          hash = {}
          keys.each { |key| hash[key] = generator.send(method) }
        end

        hash
      end
    end
  end
end
