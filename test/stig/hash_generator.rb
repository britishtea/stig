require_relative "../test_helper"
require "stig"
require "stig/generators/hash"

include Stig

setup { Stig::Generators::Hash }

test "takes a generator" do |mod|
  keys      = generator { rand }
  values    = generator { 1 }
  generator = generator_for(mod, values)

  assert_property(generator, keys) do |hash, key|
    hash[key] ==1
  end
end

test "takes a generator and a list of keys" do |mod|
  keys      = [:a, :b, :c]
  values    = generator { 1 }
  generator = generator_for(mod, values, *keys)

  assert_property(generator) do |hash|
    hash == { :a => 1, :b => 1, :c => 1 }
  end
end

test "doesn't take an invalid generator" do |mod|
  assert_raise(ArgumentError) { mod.random(1) }
end
