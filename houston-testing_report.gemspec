$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "houston/testing_report/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = "houston-testing_report"
  spec.version       = Houston::TestingReport::VERSION
  spec.authors       = ["Bob Lail"]
  spec.email         = ["bob.lailfamily@gmail.com"]

  spec.summary       = "TODO: Write a short summary, because Rubygems requires one."
  spec.description   = "TODO: Write a longer description or delete this line."
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]
  spec.test_files = Dir["test/**/*"]

  spec.add_development_dependency "bundler", "~> 1.11.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "houston-core", ">= 0.7.0.beta3"
end
