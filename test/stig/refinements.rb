require_relative "../test_helper"
require "stig"

test "doesn't pollute the global namespace" do
  [Float, Integer, String].each do |klass|
    assert_equal klass.respond_to?(:random), false

    # We just want this not to blow up.
    Stig.property(klass) { true }
  end
end
