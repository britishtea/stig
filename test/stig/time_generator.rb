require_relative "../test_helper"
require "stig"
require "stig/generators/time"

include Stig

setup { Stig::Generators::Time }

test "defaults to dates between the UNIX epoch and \"now\"" do |mod|
  range = Time.at(0)..Time.now

  assert_property(mod) do |time|
    time.class == Time
  end

  assert_property(mod) do |time|
    range.cover?(time)
  end
end

test "takes a Range" do |mod|
  range     = Time.at(200)..Time.at(300)
  generator = generator_for(mod, range)

  assert_property(generator) do |time|
    range.cover?(time)
  end
end
