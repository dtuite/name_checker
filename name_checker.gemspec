# -*- encoding: utf-8 -*-
require File.expand_path('../lib/name_checker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Tuite"]
  gem.email         = ["dtuite@gmail.com"]
  gem.description   = %q{Check the availability of a name on various services.}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "name_checker"
  gem.require_paths = ["lib"]
  gem.version       = NameChecker::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "vcr"

  gem.add_dependency "httparty"
end
