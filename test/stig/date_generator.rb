require_relative "../test_helper"
require "stig"
require "stig/generators/date"

include Stig

setup { Stig::Generators::Date }

test "generates Dates" do |mod|
  property(mod) do |date|
    assert_equal date.class, Date

    true
  end
end

test "defaults between January 1, 4713 BCE and Date.today" do |mod|
  range = Date.new..Date.today

  property(mod) do |date|
    assert range.cover?(date)

    true
  end
end

test "takes a Date Range" do |mod|
  range     = Date.new(0)..Date.new(5)
  generator = generator_for(mod, range)

  property(generator) do |date|
    assert range.cover?(date)

    true
  end
end
