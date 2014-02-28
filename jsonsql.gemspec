# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonsql/version'

Gem::Specification.new do |spec|
  spec.name          = "jsonsql"
  spec.version       = Jsonsql::VERSION
  spec.authors       = ["Francis Chong"]
  spec.email         = ["francis@ignition.hk"]
  spec.summary       = %q{Execute SQL against set of JSON files.}
  spec.description   = %q{Allows you to easily execute SQL against and experiment group of JSON files.}
  spec.homepage      = "https://github.com/siuying/jsonsql"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).grep(%r{\.git$})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_dependency "sequel"
  spec.add_dependency "sqlite3"
  spec.add_dependency "claide"
end
