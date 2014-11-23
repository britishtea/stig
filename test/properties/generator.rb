require_relative "../test_helper"
require "properties"

setup do
  Properties::Generator.new do
    1
  end
end

test "#to_gen" do |generator|
  assert generator.is_a?(Properties::Generable)
end

test "#random" do |generator|
  assert_equal generator.random, 1
end
