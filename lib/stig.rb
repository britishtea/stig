require "stig/refinements"

using Stig::Refinements

module Stig
  # Public: Number of tests that should be run.
  NUMBER_OF_RUNS = (ENV["STIG_NUMBER_OF_RUNS"] || 100).to_i
  
  # Public: Raised when a test failed.
  class AssertionFailed < StandardError; end

  module_function

  # Public: Tests a property with randomly generated input. The input comes from
  # Generators, which are passed as arguments. The property is described in the 
  # block. A test has failed when the block returns a falsy value (false or 
  # nil).
  #
  # types - An object implementing #call or #random.
  # block - A block that describes the property.
  #
  # Examples
  # 
  #   property(String, String) do |a,b|
  #     assert (a + b).start_with?(a)
  #   end
  #   
  #   property(-> { rand(10) }) do |a|
  #     assert a.between?(0, 10)
  #   end
  #
  # Returns true.
  # Raises ArgumentError when an invalid generator was supplied.
  # Raises ArgumentError when no generators were supplied.
  # Raises ArgumentError when a generator generates too few values.
  # Raises ArgumentError when no block was supplied.
  # Raises Stig::AssertionFailed when a test failed.
  def property(*types, &block)
    offenders = types.reject do |type|
      type.respond_to?(:call) || type.respond_to?(:random)
    end

    unless offenders.empty?
      msg = "no #call or #random implemented for #{offenders.join ", "}"
      raise ArgumentError, msg
    end

    unless block_given?
      raise ArgumentError, "a block is required"
    end

    if types.empty?
      raise ArgumentError, "no generators given, consider a unit test"
    end

    methods = types.map do |type|
      type.respond_to?(:call) ? :call : :random
    end

    types_and_method = types.zip(methods)

    1.upto(NUMBER_OF_RUNS) do |i|
      input = types_and_method.map { |type, method| type.send(method) }

      result = yield(*input)

      unless result
        parameters = block.parameters.map(&:last).first(input.size)
        formatted  = parameters.zip(input).map do |a,v|
          "- #{a} => #{v.inspect} (#{v.class})"
        end

        message = "Failed after #{i} test(s) with input\n" \
        "#{formatted.join "\n"}"

        raise AssertionFailed, message
      end
    end

    return true
  end

  # Public: Creates a generator from a block.
  #
  # args  - Any arguments that should be passed to the block.
  # block - A block returning a random value.
  #
  # Examples
  #
  #   float_generator = Stig.generator do
  #     rand
  #   end
  #
  #   number_generator = Stig.generator(1, 100) do |min, max
  #     rand(min..max)
  #   end
  #
  # Returns a Proc.
  # Raises ArgumentError if no block was passed.
  def generator(*args, &block)
    unless block_given?
      raise ArgumentError, "no block given"
    end

    args.empty? ? block : proc { yield(*args) }
  end

  # Public: Creates a generator from an object. The object should respond to
  # #random.
  #
  # object - An object implementing #random.
  # args   - Any arguments that should be passed to object#random.
  #
  # Examples
  #
  #   # Assuming Integer.random is implemented and takes two arguments.
  #   integer_generator = generator_for(Integer, 1, 10)
  #
  # Returns a Proc.
  # Raises ArgumentError if `object` does not respond to #random.
  def generator_for(object, *args)
    unless object.respond_to?(:random)
      raise ArgumentError, "no #random implemented for #{object}"
    end

    generator(*args, &object.method(:random))
  end
end
