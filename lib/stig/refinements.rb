require "stig/generators/float"
require "stig/generators/integer"
require "stig/generators/string"
require "stig/generators/symbol"

module Stig
  # Public: Refinements for the core classes Array, Float, Integer and String.
  module Refinements
    # Internal: Fixes respond_to? for refined classes.
    module Fix
      def respond_to?(method, *args)
        method == :random ? true : super
      end
    end

    refine Float.singleton_class do
      include Generators::Float, Fix
    end

    refine Integer.singleton_class do
      include Generators::Integer, Fix
    end

    refine String.singleton_class do
      include Generators::String, Fix
    end

    refine Symbol.singleton_class do
      include Generators::Symbol, Fix
    end
  end
end
