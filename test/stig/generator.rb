require_relative "../test_helper"
require "stig"

setup { Stig }

prepare { $test = nil }

test "without a block" do |stig|
  assert_raise(ArgumentError) { stig.generator }
end

test "with a block" do |stig|
  generator = stig.generator { 1 }

  assert_equal generator.class, Proc
  assert_equal generator.call, 1
end

test "with a block taking arguments" do |stig|
  arguments = [:a, :b, :c]
  generator = stig.generator(*arguments) { |*args| args }

  assert_equal generator.call, arguments
end

test "with an object without a #random" do |stig|
  assert_raise(ArgumentError) { stig.generator_for "no #random" }
end

test "with an object responding to #random" do |stig|
  object = Object.new
  object.define_singleton_method(:random) { 1 }

  generator = stig.generator_for(object)

  assert_equal generator.class, Proc
  assert_equal generator.call, 1
end

test "with an object taking arguments" do |stig|
  object = Object.new
  object.define_singleton_method(:random) { |*args| args }

  arguments = [:a, :b, :c]
  generator = stig.generator_for(object, *arguments)

  assert_equal generator.call, arguments
end
