require "stig/refinements"

using Stig::Refinements

module Stig
  # Public: Raised when a test failed.
  class AssertionFailed < StandardError; end

  module_function

  # Public: Tests a property with randomly generated input. The input comes from
  # Generators, which are passed as arguments. The property is described in the 
  # block. A test has failed when the block returns a falsy value (false or 
  # nil).
  #
  # types - Enumerators or objects responding to #random.
  # block - A block that describes the property.
  #
  # Examples
  # 
  #   property(String, String) do |a,b|
  #     assert (a + b).start_with?(a)
  #   end
  #   
  #   property([1,2,3].each, [1,2,3].each) do |a,b|
  #     assert (a + b).is_a?(Integer)
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
      type.respond_to?(:random) || type.is_a?(Enumerator)
    end

    unless offenders.empty?
      raise ArgumentError, "no #random implemented for #{offenders.join ", "}"
    end

    unless block_given?
      raise ArgumentError, "a block is required"
    end

    if types.empty?
      raise ArgumentError, "no generators given, consider a unit test"
    end

    1.upto(100) do |i|
      input = types.map do |type|
        type.is_a?(Enumerator) ? type.next : type.random
      end

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
  rescue StopIteration
    offender = types
      .select { |type| type.respond_to?(:peek) }
      .find { |gen| gen.peek && false rescue true }

    raise ArgumentError, "#{offender} generates too few values"
  end

  # Public: Creates a generator from a block.
  #
  # args - Any arguments that should be passed to the block.
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
  #   # Assuming Symbol.random is implemented
  #   symbol_generator = Stig.generator &Symbol.method(:random)
  #
  # Returns an Enumerator.
  # Raises ArgumentError if no block was passed.
  def generator(*args, &block)
    unless block_given?
      raise ArgumentError, "no block given"
    end

    Enumerator.new(Float::INFINITY) do |yielder|
      loop { yielder << yield(*args) }
    end
  end

  # Public: Creates a generator from an object. The object should respond to
  # #random.
  #
  # object - An object responding to #random.
  # args   - Any arguments that should be passed to object#random.
  #
  # Examples
  #
  #   # Assuming Integer.random is implemented and takes two arguments.
  #   integer_generator = generator_for(Integer, 1, 10)
  #
  # Returns an Enumerator.
  # Raises ArgumentError if `object` does not respond to #raw.
  def generator_for(object, *args)
    unless object.respond_to?(:random)
      raise ArgumentError, "no #random implemented for #{object}"
    end

    Enumerator.new(Float::INFINITY) do |yielder|
      loop { yielder << object.random(*args) }
    end
  end
end
