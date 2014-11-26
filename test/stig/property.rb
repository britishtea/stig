require_relative "../test_helper"
require "stig"

TEST_GENERATOR = [1].cycle
VERBOSITY      = $VERBOSE

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
    stig.property("invalid", TEST_GENERATOR) { true }
  end

  assert_raise(ArgumentError) do
    stig.property([].each) { true }
  end
end

test "valid generators" do |stig|
  stig.property(TEST_GENERATOR, 100.times) do |i,j|
    assert_equal i, 1
    assert_equal j, $test

    $test += 1
  end
end

test "no property" do |stig|
  assert_raise(ArgumentError) do
    stig.property(TEST_GENERATOR)
  end
end

test "failing test" do |stig|
  assert_raise(Stig::AssertionFailed) do
    stig.property(TEST_GENERATOR) { |i| false }
  end
end

test "passing tests" do |stig|
  assert stig.property(TEST_GENERATOR) { |i| true }
end

test "default number of runs" do |stig|
  stig.property(TEST_GENERATOR) { $test += 1 }

  assert_equal $test, 100
end

test "configure number of runs with constant" do |stig|
  $VERBOSE = nil
  stig::NUMBER_OF_RUNS = 101
  $VERBOSE = VERBOSITY

  stig.property(TEST_GENERATOR) { $test += 1 }

  assert_equal $test, 101 
end

test "configure number of runs with environment variable" do |stig|
  ENV["STIG_NUMBER_OF_RUNS"] = "101"
  
  $VERBOSE = nil
  load "stig.rb"
  $VERBOSE = VERBOSITY

  stig.property(TEST_GENERATOR) { $test += 1 }

  assert_equal $test, 101
end
