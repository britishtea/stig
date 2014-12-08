require_relative "../test_helper"
require "stig"
require "stig/generators/integer"

include Stig

setup { Stig::Generators::Integer }

test "takes a maximum value" do |mod|
  generator = generator_for(mod, 10)

  assert_property(generator) do |integer|
    integer.between?(0, 10)
  end
end

test "takes a range" do |mod|
  generator = generator_for(mod, 5..10)

  assert_property(generator) do |integer|
    integer.between?(5, 10)
  end
end

test "defaults to Integers between 0 and 100" do |mod|
  assert_property(mod) do |integer|
    integer.between?(0, 100)
  end
end
