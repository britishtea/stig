require_relative "../test_helper"
require "stig"
require "stig/generators/time"

include Stig

setup { Stig::Generators::Time }

test "defaults to dates between the UNIX epoch and \"now\"" do |mod|
  generator = generator_for(mod)
  range     = Time.at(0)..Time.now

  property(generator) do |time|
    assert_equal time.class, Time

    true
  end

  property(generator) do |time|
    assert range.cover?(time)

    true
  end
end

test "takes a Range" do |mod|
  range     = Time.at(200)..Time.at(300)
  generator = generator_for(mod, range)

  property(generator) do |time|
    assert range.cover?(time)

    true
  end
end
