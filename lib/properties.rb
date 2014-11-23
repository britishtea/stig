module Properties
  # Public: Provides a way to turn an object's #random into a generator. Note 
  # that the object should have a #random defined.
  #
  # Examples
  #
  #   class Integer
  #     extend Properties::Generable
  #     
  #     def self.random(min, max)
  #       rand(min..max)
  #     end
  #   end
  module Generable
    # Public: Turns an object into an Enumerator suitable for consumption by
    # Properties#property. Note that the Enumerator is cached in the instance 
    # variable `@__GENERATOR__`.
    #
    # args  - Any arguments that should be passed to #random.
    # block - A block that should be passed to #random.
    #
    # Returns an Enumerator.
    def to_gen(*args, &block)
      @__GENERATOR__ ||= begin
        unless self.respond_to?(:random)
          raise ArgumentError, "#{self}.random is not implemented"
        end

        Enumerator.new(Float::INFINITY) do |yielder|
          loop { yielder << self.random(*args, &block) }
        end
      end
    end
  end

  class Generator
    include Generable

    # Public: ...
    #
    # block - A block that returns a random value.
    #
    # Examples
    #
    #   Character = Properties::Generator.new do |*set|
    #     set.sample
    #   end
    #
    #   generator = Character.random("a".."z")
    #   # => "e"
    def initialize(&block)
      @block = block
    end

    # Public: Calls the generator block (the block passed to initialize) with 
    # *args and &block.
    #
    # args  - Any arguments that should be passed to the block.
    # block - A block that should be passed to the generator block.
    #
    # Returns the result of the block.
    def random(*args, &block)
      @block.call(*args, &block)
    end
  end

  class AssertionFailed < StandardError
  end

  module_function

  # Public: Tests a property with randomly generated input. The input comes from
  # Generators, which are passed as arguments. The property is described in the 
  # block. A test has failed when the block returns a falsy value (false or 
  # nil).
  #
  # types - Objects responding to #to_gen or Enumerators.
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
  # Raises ArgumentError when invalid arguments are received.
  # Raises Properties::AssertionFailed when a test failed.
  def property(*types, &block)
    offenders = types.reject do |type|
      type.respond_to?(:to_gen) || type.is_a?(Enumerator)
    end

    unless offenders.empty?
      raise ArgumentError, "no #to_gen implemented for #{offenders.join ", "}"
    end

    unless block_given?
      raise ArgumentError, "a block is required"
    end

    if types.empty?
      raise ArgumentError, "no generators given, consider a unit test"
    end

    generators = types.map do |type|
      type.is_a?(Enumerator) ? type : type.to_gen
    end

    1.upto(100) do |i|
      input  = generators.map(&:next)
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
    raise "generator exhausted"
  end
end
