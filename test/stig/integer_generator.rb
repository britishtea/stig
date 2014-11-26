require_relative "../test_helper"
require "stig"
require "stig/generators/integer"

include Stig

setup { Stig::Generators::Integer }

test "takes a maximum value" do |mod|
  generator = generator_for(mod, 10)

  property(generator) do |integer|
    assert integer.between?(0, 10)

    true
  end
end

test "takes a range" do |mod|
  generator = generator_for(mod, 5..10)

  property(generator) do |integer|
    assert integer.between?(5, 10)

    true
  end
end

test "defaults to Integers between 0 and 100" do |mod|
  property(mod) do |integer|
    assert integer.between?(0, 100)

    true
  end
end
