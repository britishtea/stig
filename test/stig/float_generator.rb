require_relative "../test_helper"
require "stig"
require "stig/generators/float"

include Stig

setup { Stig::Generators::Float }

test "takes a maximum value" do |mod|
  generator = generator_for(mod, 10.0)

  assert_property(generator) do |integer|
    integer.between?(0.0, 10.0)
  end
end

test "takes a range" do |mod|
  generator = generator_for(mod, 5.0..10.0)

  assert_property(generator) do |integer|
    integer.between?(5.0, 10.0)
  end
end

test "defaults to Floats between 0.0 and 1.0" do |mod|
  assert_property(mod) do |integer|
    integer.between?(0.0, 1.0)
  end
end
