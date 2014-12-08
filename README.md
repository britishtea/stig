# stig

Simple test input generation.

## What is it

Stig is a small library for property based testing in Ruby. It runs a test
multiple times (100 by default) with randomly generated input. Stig is test
framework agnostic, so can be used with any test framework.

## Usage

An example using [cutest][cutest]. `test` and `assert_raise` come from cutest.

```ruby
require "stig"

test "doesn't parse random input" do
  Stig.property(String) do |string|
    assert_raise { Library.parse(string) }
  end
end
```

`Stig.property` takes one or more generators and a predicate block. A generator
is an object implementing `#call` or `#random`. A predicate block is a block
that returns `true` for passed tests and `false` for failed test.

**Note**: *In the above example `String` is used as generator. Stig doesn't
monkey-patch any classes. Refinements are used instead.*

### Generators

Stig ships with a few built in generators, such as `Date`, `Integer` and 
`String`. They can be found under the `Stig::Generators` namespace. It's easy to
write your own generators using `Stig.generator` and `Stig.generator_for`.

An example of creating a custom generator using `Stig.generator`.

```ruby
Person = Struct.new(:name, :age)

person_generator = generator do
  Person.new Generators::String.random, Generators::Integer.random(99)
end

person_generator.call
# => #<struct Person name="M#uVfd7\tx\x1Eri]\x1F\x7F", age=95>
```

An example of creating a custom generator using `Stig.generator_for`.

```ruby
Person = Struct.new(:name, :age) do
  def self.random
    new Generators::String.random, Generators::Integer.random(99)
  end
end

person_generator = generator_for(Person)

person_generator.call
# => #<struct Person name="-\x069|\x0F\x03Llq", age=6>
```

To configure the number of tests stig should run set the environment variable 
`STIG_NUMBER_OF_RUNS` to the desired number of test runs.

[cutest]: https://github.com/djanowski/cutest

## Installation

`gem install stig`

Stig requires Ruby 2.0.0 or higher.

## License

See the LICENSE file.
