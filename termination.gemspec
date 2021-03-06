# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'termination/version'

Gem::Specification.new do |gem|
  gem.name          = "termination"
  gem.version       = Termination::VERSION
  gem.authors       = ["Adam"]
  gem.email         = ["adam.williams@incuentra.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'term-ansicolor'
  gem.add_dependency 'coderay'
  gem.add_dependency 'ansi'
  gem.add_dependency 'artii'
end
