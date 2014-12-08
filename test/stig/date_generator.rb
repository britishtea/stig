require_relative "../test_helper"
require "stig"
require "stig/generators/date"

include Stig

setup { Stig::Generators::Date }

test "generates Dates" do |mod|
  assert_property(mod) do |date|
    date.class == Date
  end
end

test "defaults between January 1, 4713 BCE and Date.today" do |mod|
  range = Date.new..Date.today

  assert_property(mod) do |date|
    range.cover?(date)
  end
end

test "takes a Date Range" do |mod|
  range     = Date.new(0)..Date.new(5)
  generator = generator_for(mod, range)

  assert_property(generator) do |date|
    range.cover?(date)
  end
end
