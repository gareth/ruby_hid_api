# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hid_api/version'

Gem::Specification.new do |spec|
  spec.name          = "hid_api"
  spec.version       = HidApi::VERSION
  spec.licenses      = ["MIT"]
  spec.authors       = ["Gareth Adams"]
  spec.email         = ["g@rethada.ms"]

  spec.summary       = %q{A Ruby FFI wrapper around the System11 hidapi C library}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/gareth/ruby_hid_api"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi", "~> 1.9"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rspec", "> 0"

  spec.add_development_dependency "pry", "> 0"
  spec.add_development_dependency "awesome_print", "> 0"
end
