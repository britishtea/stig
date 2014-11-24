require_relative "../test_helper"
require "properties"
require "properties/generators/integer"

include Properties

setup { Properties::Generators }

test "takes a maximum value" do |namespace|
  generator = generator(10, &namespace::Integer.method(:random))

  property(generator) do |integer|
    assert integer.between?(0, 10)

    true
  end
end

test "takes a range" do |namespace|
  generator = generator(5..10, &namespace::Integer.method(:random))

  property(generator) do |integer|
    assert integer.between?(5, 10)

    true
  end
end

test "defaults to Integers between 0 and 100" do |namespace|
  generator = generator(&namespace::Integer.method(:random))

  property(generator) do |integer|
    assert integer.between?(0, 100)

    true
  end
end
