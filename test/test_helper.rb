$:.unshift File.expand_path('../../lib', __FILE__)

def assert_property(*args, &block)
  assert Stig.property(*args, &block)
end
