require_relative "../test_helper"
require "properties"

setup { Properties }

prepare { $test = nil }

test "without a block" do |namespace|
  assert_raise(ArgumentError) { namespace.generator }
end

test "with a block" do |namespace|
  generator = namespace.generator { 1 }

  assert_equal generator.class, Enumerator
  assert_equal generator.size, Float::INFINITY
  assert_equal generator.take(100).uniq, [1]
end

test "with a block taking arguments" do |namespace|
  arguments = [:a, :b, :c]
  generator = namespace.generator(*arguments) { |*args| args }

  assert_equal generator.take(100).uniq, [arguments]
end

test "with an object without a #random" do |namespace|
  assert_raise(ArgumentError) { namespace.generator_for "no #random" }
end

test "with an object responding to #random" do |namespace|
  object = Object.new
  object.define_singleton_method(:random) { 1 }

  generator = namespace.generator_for(object)

  assert_equal generator.class, Enumerator
  assert_equal generator.size, Float::INFINITY
  assert_equal generator.take(100).uniq, [1]
end

test "with an object taking arguments" do |namespace|
  object = Object.new
  object.define_singleton_method(:random) { |*args| args }

  arguments = [:a, :b, :c]
  generator = namespace.generator_for(object, *arguments)

  assert_equal generator.take(100).uniq, [arguments]
end
