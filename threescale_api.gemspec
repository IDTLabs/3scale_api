# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'threescale_api/version'

Gem::Specification.new do |spec|
  spec.name          = "threescale_api"
  spec.version       = ThreescaleApi::VERSION
  spec.authors       = ["Robbie Holmes"]
  spec.email         = ["robbiethegeek@gmail.com"]
  spec.summary       = %q{3Scale API client gem.}
  spec.description   = %q{This gem is to be used to interact with 3Scale's API.}
  spec.homepage      = "https://github.com/IDTLabs/threescale_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.test_files = Dir.glob("test/**/*.rb")
end
