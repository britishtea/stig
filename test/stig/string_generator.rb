require_relative "../test_helper"
require "stig"
require "stig/generators/string"

include Stig

setup { Stig::Generators::String }

test "defaults to all ASCII characters with maximum length 25" do |mod|
  set = Stig::Generators::Character::ASCII

  property(mod) do |string|
    assert string.chars.all? { |char| set.include? char }

    true
  end

  property(mod) do |string|
    assert string.size.between?(0, 25)

    true
  end
end

test "takes character sets" do |mod|
  generator = generator_for(mod, ["a"])

  property(generator) do |string|
    assert_equal string.class, String

    true
  end

  property(generator) do |string|
      assert [["a"], []].include?(string.chars.uniq)

    true
  end
end

test "doesn't take an empty character set" do |mod|
  assert_raise(ArgumentError) { mod.random([]) }
end

test "takes a maximum length" do |mod|
  generator = generator_for(mod, ["a"], 10)
  
  property(generator) do |string|
    assert string.size.between?(0, 10)

    true
  end
end

test "takes a range as length" do |mod|
  generator = generator_for(mod, ["a"], 5..10)

  property(generator) do |string|
    assert string.size.between?(5, 10)

    true
  end
end
