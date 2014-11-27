module Stig
  module Generators
    module Hash
      extend self

      # Public: Generates a random Hash. If no keys are passed, a Hash with a
      # default proc is returned.
      #
      # generator - An object implementing #call or #random.
      # keys      - Objects to use as Hash keys.
      #
      # Returns a Hash.
      # Raises ArgumentError when an invalid generator was supplied.
      def random(generator, *keys)
        unless generator.respond_to?(:call) || generator.respond_to?(:random)
          msg = "no #call or #random implemented for #{generator}"
          raise ArgumentError, msg
        end

        method = generator.respond_to?(:call) ? :call : :random

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
