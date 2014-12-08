require_relative "../test_helper"
require "stig"
require "stig/generators/string"

include Stig

setup { Stig::Generators::Character }

test "defaults to all ASCII characters" do |mod|
  assert_property(mod) do |character|
    character.class == String
  end

  assert_property(mod) do |character|
    character.size == 1
  end

  assert_property(mod) do |character|
    0.upto(127).map(&:chr).include?(character)
  end
end

test "takes a character set" do |mod|
  generator = generator_for(mod, ["a"])

  assert_property(generator) do |character|
    character == "a"
  end
end

test "doesn't take an empty character set" do |mod|
  assert_raise(ArgumentError) { mod.random([]) }
end
