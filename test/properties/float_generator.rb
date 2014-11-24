require_relative "../test_helper"
require "properties"
require "properties/generators/float"

include Properties

setup { Properties::Generators }

test "takes a maximum value" do |namespace|
  generator = generator(10.0, &namespace::Float.method(:random))

  property(generator) do |integer|
    assert integer.between?(0.0, 10.0)

    true
  end
end

test "takes a range" do |namespace|
  generator = generator(5.0..10.0, &namespace::Float.method(:random))

  property(generator) do |integer|
    assert integer.between?(5.0, 10.0)

    true
  end
end

test "defaults to Floats between 0.0 and 1.0" do |namespace|
  generator = generator(&namespace::Float.method(:random))

  property(generator) do |integer|
    assert integer.between?(0.0, 1.0)

    true
  end
end
