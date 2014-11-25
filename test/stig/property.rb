require_relative "../test_helper"
require "stig"

TEST_GENERATOR = [1].cycle

setup { Stig }

prepare { $test = 0 }

test "no generators" do |namespace|
  assert_raise(ArgumentError) do
    namespace.property { true }
  end
end

test "invalid generators" do |namespace|
  assert_raise(ArgumentError) do
    namespace.property("invalid", TEST_GENERATOR) { true }
  end

  assert_raise(ArgumentError) do
    namespace.property([].each) { true }
  end
end

test "valid generators" do |namespace|
  namespace.property(TEST_GENERATOR, 100.times) do |i,j|
    assert_equal i, 1
    assert_equal j, $test

    $test += 1
  end
end

test "no property" do |namespace|
  assert_raise(ArgumentError) do
    namespace.property(TEST_GENERATOR)
  end
end

test "failing test" do |namespace|
  assert_raise(Stig::AssertionFailed) do
    namespace.property(TEST_GENERATOR) { |i| false }
  end
end

test "passing tests" do |namespace|
  assert namespace.property(TEST_GENERATOR) { |i| true }
end

test "number of runs" do |namespace|
  namespace.property(TEST_GENERATOR) { $test += 1 }

  assert_equal $test, 100
end
