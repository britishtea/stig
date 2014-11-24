require "properties/generators/character"

module Properties
  module Generators
    module String
      # Public: Generates a random String.
      #
      # set  - An Array of objects responding to #chr (default: ASCII).
      # size - A maximum length Integer or Range (default: 25).
      #
      # Returns a String.
      def self.random(set = Character::ASCII, size = 25)
        Array.new(rand(size)) { Character.random(set) }.join
      end
    end
  end
end
