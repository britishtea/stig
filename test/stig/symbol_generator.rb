require_relative "../test_helper"
require "stig"
require "stig/generators/symbol"

include Stig

setup { Stig::Generators::Symbol }

test "defaults to all ASCII characters with maximum length 25" do |mod|
  set = Stig::Generators::Character::ASCII

  assert_property(mod) do |symbol|
    symbol.to_s.chars.all? { |char| set.include? char }
  end

  assert_property(mod) do |symbol|
    symbol.size.between?(0, 25)
  end
end

test "takes character sets" do |mod|
  generator = generator_for(mod, ["a"])

  assert_property(generator) do |symbol|
    symbol.class == Symbol
  end

  assert_property(generator) do |symbol|
    [["a"], []].include?(symbol.to_s.chars.to_a.uniq)
  end
end

test "doesn't take an empty character set" do |mod|
  assert_raise(ArgumentError) { mod.random([]) }
end

test "takes a maximum length" do |mod|
  generator = generator_for(mod, ["a"], 10)
  
  assert_property(generator) do |symbol|
    symbol.size.between?(0, 10)
  end
end

test "takes a range as length" do |mod|
  generator = generator_for(mod, ["a"], 5..10)

  assert_property(generator) do |symbol|
    symbol.size.between?(5, 10)
  end
end
