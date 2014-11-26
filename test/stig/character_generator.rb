require_relative "../test_helper"
require "stig"
require "stig/generators/string"

include Stig

setup { Stig::Generators::Character }

test "defaults to all ASCII characters" do |mod|
  property(mod) do |character|
    assert_equal character.class, String

    true
  end

  property(mod) do |character|
    assert_equal character.size, 1

    true
  end

  property(mod) do |character|
    assert 0.upto(127).map(&:chr).include?(character)

    true
  end
end

test "takes a character set" do |mod|
  generator = generator_for(mod, ["a"])

  property(generator) do |character|
    assert_equal character, "a"

    true
  end
end

test "doesn't take an empty character set" do |mod|
  assert_raise(ArgumentError) { mod.random([]) }
end
