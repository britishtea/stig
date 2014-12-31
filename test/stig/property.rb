require_relative "../test_helper"
require "stig"

GENERATOR = proc { 1 }
VERBOSITY = $VERBOSE

setup { Stig }

prepare do
  $VERBOSE = VERBOSITY
  $test    = 0
end

test "no generators" do |stig|
  assert_raise(ArgumentError) do
    stig.property { true }
  end
end

test "invalid generators" do |stig|
  assert_raise(ArgumentError) do
    stig.property("invalid", GENERATOR) { true }
  end

  assert_raise(ArgumentError) do
    stig.property([].each) { true }
  end
end

test "an object implementing #call as generator" do |stig|
  generator = proc { 1 }

  stig.property(generator) do |i|
    assert_equal i, 1

    true
  end
end

test "an object implemeting #random as generator" do |stig|
  generator = Object.new
  generator.define_singleton_method(:random) { 1 }

  stig.property(generator) do |i|
    assert_equal i, 1

    true
  end
end

test "multiple generators" do |stig|
  stig.property(GENERATOR, GENERATOR, GENERATOR) do |i,j,k|
    assert_equal i, 1
    assert_equal j, 1
    assert_equal k, 1

    true
  end
end

test "no property" do |stig|
  assert_raise(ArgumentError) { stig.property(GENERATOR) }
end

test "raises when a test fails" do |stig|
  assert_raise(Stig::AssertionFailed) do
    stig.property(GENERATOR) { false }
  end
end

test "return true when all tests pass" do |stig|
  assert stig.property(GENERATOR) { |i| true }
end

test "default number of runs" do |stig|
  stig.property(GENERATOR) { $test += 1 }

  assert_equal $test, 100
end

test "configure number of runs with constant" do |stig|
  $VERBOSE = nil
  stig::NUMBER_OF_RUNS = 2
  $VERBOSE = VERBOSITY

  stig.property(GENERATOR) { $test += 1 }

  assert_equal $test, 2 
end

test "configure number of runs with environment variable" do |stig|
  ENV["STIG_NUMBER_OF_RUNS"] = "2"
  
  $VERBOSE = nil
  load "stig.rb"
  $VERBOSE = VERBOSITY

  stig.property(GENERATOR) { $test += 1 }

  assert_equal $test, 2
end

test "works with core classes" do |stig|
  [Date, Float, Integer, String, Symbol, Time].each do |generator|
    stig.property(generator) { true }
  end
end
