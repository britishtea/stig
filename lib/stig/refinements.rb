require "stig/generators/float"
require "stig/generators/integer"
require "stig/generators/string"
require "stig/generators/symbol"
require "stig/generators/time"

module Stig
  # Public: Refinements for the core classes Array, Float, Integer and String.
  module Refinements
    # A note on refinements.
    #
    # There are a few issues with refinements:
    #
    # 1. Refined class methods are ignored. Calling them results in a 
    #    NoMethodError.
    # 2. #respond_to? ignores refined methods. It returns `false` for methods
    #    that have been refined.
    # 3. #send ignores refined methods. It raises a NoMethodError when trying
    #    to invoke a refined method.
    #
    # Issues 2 and 3 aren't bugs, see: http://goo.gl/335ndw.
    #
    # Stig uses the following workarounds:
    #
    # 1. To refine class method, the singleton class is refined.
    # 2. #respond_to? is refined. It checks for existing methods manually. The 
    #    module Fix is included in the refinement.
    # 3. #send is refined. Unfortunately, this cannot be done by including a 
    #    module in the refinement. #send needs to be defined directly in the 
    #    refinement or it will be ignored. It also requires any method it calls
    #    to be defined directly in the refinement.
    # 
    # It's a pity.

    # Internal: Fixes #respond_to? for refined classes.
    module Fix
      def respond_to?(method, *args)
        method == :random ? true : super
      end
    end

    refine Float.singleton_class do
      include Fix

      def random(*args, &block)
        Generators::Float.random(*args, &block)
      end

      def send(method, *args, &block)
        method == :random ? random(*args, &block) : super
      end
    end

    refine Integer.singleton_class do
      include Fix

      def random(*args, &block)
        Generators::Integer.random(*args, &block)
      end

      def send(method, *args, &block)
        method == :random ? random(*args, &block) : super
      end
    end

    refine String.singleton_class do
      include Fix

      def random(*args, &block)
        Generators::String.random(*args, &block)
      end

      def send(method, *args, &block)
        method == :random ? random(*args, &block) : super
      end
    end

    refine Symbol.singleton_class do
      include Fix

      def random(*args, &block)
        Generators::Symbol.random(*args, &block)
      end

      def send(method, *args, &block)
        method == :random ? random(*args, &block) : super
      end
    end

    refine Time.singleton_class do
      include Fix

      def random(*args, &block)
        Generators::Time.random(*args, &block)
      end

      def send(method, *args, &block)
        method == :random ? random(*args, &block) : super
      end
    end
  end
end
