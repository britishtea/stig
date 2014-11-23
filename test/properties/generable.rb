require_relative "../test_helper"
require "properties"

setup do
  Class.new do
    extend Properties::Generable

    def self.random
      1
    end
  end
end

test "#to_gen" do |klass|
  generator = klass.to_gen

  assert_equal generator.class, Enumerator
  assert_equal generator.take(100).uniq, [1]
  assert_equal generator.size, Float::INFINITY
end
