require_relative "../test_helper"
require "properties"
require "properties/generators/string"

include Properties

setup { Properties::Generators }

test "defaults to all ASCII characters with maximum length 25" do |namespace|
  set       = namespace::Character::ASCII
  generator = generator(&namespace::String.method(:random))

  property(generator) do |string|
    assert string.chars.all? { |char| set.include? char }

    true
  end

  property(generator) do |string|
    assert string.size.between?(0, 25)

    true
  end
end

test "takes character sets" do |namespace|
  generator = generator(["a"], &namespace::String.method(:random))

  property(generator) do |string|
    assert_equal string.class, String

    true
  end

  property(generator) do |string|
      assert [["a"], []].include?(string.chars.uniq)

    true
  end
end

test "doesn't take an empty character set" do |namespace|
  assert_raise(ArgumentError) { namespace::String.random([]) }
end

test "takes a maximum length" do |namespace|
  generator = generator(["a"], 10, &namespace::String.method(:random))
  
  property(generator) do |string|
    assert string.size.between?(0, 10)

    true
  end
end

test "takes a range as length" do |namespace|
  generator = generator(["a"], 5..10, &namespace::String.method(:random))

  property(generator) do |string|
    assert string.size.between?(5, 10)

    true
  end
end
