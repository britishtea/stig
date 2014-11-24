require_relative "../test_helper"
require "properties"
require "properties/generators/string"

include Properties

setup { Properties::Generators }

test "defaults to all ASCII characters" do |namespace|
  generator = generator(&namespace::Character.method(:random))

  property(generator) do |character|
    assert_equal character.class, String

    true
  end

  property(generator) do |character|
    assert_equal character.size, 1

    true
  end

  property(generator) do |character|
    assert 0.upto(127).map(&:chr).include?(character)

    true
  end
end

test "takes a character set" do |namespace|
  generator = generator(["a"], &namespace::Character.method(:random))

  property(generator) do |character|
    assert_equal character, "a"

    true
  end
end

test "calls #chr on objects in the character set" do |namespace|
  custom = Object.new
  custom.define_singleton_method(:chr) { "a" }

  # 97 is the ASCII number for "a"
  set       = ["a", 97, custom]
  generator = generator(set, &namespace::Character.method(:random))

  property(generator) do |character|
    assert_equal character, "a"

    true
  end
end

test "doesn't take objects not responding to #chr" do |namespace|
  assert_raise(ArgumentError) { namespace::Character.random([Object.new]) }
end

test "doesn't take an empty character set" do |namespace|
  assert_raise(ArgumentError) { namespace::Character.random([]) }
end
