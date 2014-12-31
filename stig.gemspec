require_relative "lib/stig/version"

Gem::Specification.new do |s|
  s.name        = "stig"
  s.version     = Stig::VERSION
  s.summary     = "simple test input generation"
  s.description = "Stig is a small library for property based testing in Ruby."
  s.author      = "Jip van Reijsen"
  s.email       = "jipvanreijsen@gmail.com"
  s.homepage    = "https://github.com/britishtea/stig"
  s.license     = "MIT"

  s.files                 = `git ls-files`.split("\n")
  s.extra_rdoc_files      = ["README.md"]
  s.required_ruby_version = '>= 1.9.3'
  
  s.add_development_dependency "cutest", "~> 1.2"
end
