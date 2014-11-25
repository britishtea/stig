require_relative "../test_helper"
require "stig"
require "stig/generators/array"

include Stig

setup { Stig::Generators }

test "takes a generator" do |namespace|
  elements  = generator { 1 }
  generator = generator_for(namespace::Array, elements)

  property(generator) do |array|
    assert_equal array.uniq, [1]

    true
  end
end

test "doesn't take an invalid generator" do |namespace|
  assert_raise(ArgumentError) do
    namespace::Array.random("invalid")
  end
end

test "defaults to Arrays with length between 1 and 10" do |namespace|
  elements = generator { 1 }
  generator = generator_for(namespace::Array, elements)

  property(generator) do |array|
    assert array.size.between?(1, 10)

    true
  end
end

test "takes a maximum size" do |namespace|
  elements  = generator { 1 }
  generator = generator_for(namespace::Array, elements, 5)

  property(generator) do |array|
    assert array.size.between?(0, 5)

    true
  end
end

test "takes a range" do |namespace|
  elements = generator { 1 }
  generator = generator_for(namespace::Array, elements, 1..5)

  property(generator) do |array|
    assert array.size.between?(1, 5)

    true
  end
end
