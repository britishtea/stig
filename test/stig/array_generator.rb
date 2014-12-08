require_relative "../test_helper"
require "stig"
require "stig/generators/array"

include Stig

setup { Stig::Generators::Array }

test "takes a generator" do |mod|
  elements  = generator { 1 }
  generator = generator_for(mod, elements)

  assert_property(generator) do |array|
    array.uniq == [1]
  end
end

test "doesn't take an invalid generator" do |mod|
  assert_raise(ArgumentError) { mod.random("invalid") }
end

test "defaults to Arrays with length between 1 and 10" do |mod|
  elements  = generator { 1 }
  generator = generator_for(mod, elements)

  assert_property(generator) do |array|
    array.size.between?(1, 10)
  end
end

test "takes a maximum size" do |mod|
  elements  = generator { 1 }
  generator = generator_for(mod, elements, 5)

  assert_property(generator) do |array|
    array.size.between?(0, 5)
  end
end

test "takes a range" do |mod|
  elements  = generator { 1 }
  generator = generator_for(mod, elements, 1..5)

  assert_property(generator) do |array|
    array.size.between?(1, 5)
  end
end
