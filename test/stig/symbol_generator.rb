require_relative "../test_helper"
require "stig"
require "stig/generators/symbol"

include Stig

setup { Stig::Generators::Symbol }

test "defaults to all ASCII characters with maximum length 25" do |mod|
  set       = Stig::Generators::Character::ASCII
  generator = generator_for(mod)

  property(generator) do |symbol|
    assert symbol.to_s.chars.all? { |char| set.include? char }

    true
  end

  property(generator) do |symbol|
    assert symbol.size.between?(0, 25)

    true
  end
end

test "takes character sets" do |mod|
  generator = generator_for(mod, ["a"])

  property(generator) do |symbol|
    assert_equal symbol.class, Symbol

    true
  end

  property(generator) do |symbol|
      assert [["a"], []].include?(symbol.to_s.chars.uniq)

    true
  end
end

test "doesn't take an empty character set" do |mod|
  assert_raise(ArgumentError) { mod.random([]) }
end

test "takes a maximum length" do |mod|
  generator = generator_for(mod, ["a"], 10)
  
  property(generator) do |symbol|
    assert symbol.size.between?(0, 10)

    true
  end
end

test "takes a range as length" do |mod|
  generator = generator_for(mod, ["a"], 5..10)

  property(generator) do |symbol|
    assert symbol.size.between?(5, 10)

    true
  end
end
