require_relative "../test_helper"
require "stig"
require "stig/generators/hash"

include Stig

setup { Stig::Generators::Hash }

test "takes a generator" do |mod|
  keys      = generator { rand }
  values    = generator { 1 }
  generator = generator_for(mod, values)

  property(generator, keys) do |hash, key|
    assert_equal hash[key], 1

    true
  end
end

test "takes a generator and a list of keys" do |mod|
  keys      = [:a, :b, :c]
  values    = generator { 1 }
  generator = generator_for(mod, values, *keys)

  property(generator) do |hash|
    assert_equal hash, :a => 1, :b => 1, :c => 1

    true
  end
end

test "doesn't take an invalid generator" do |mod|
  assert_raise(ArgumentError) { mod.random(1) }
end
