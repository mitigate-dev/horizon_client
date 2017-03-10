# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'horizon_client/version'

Gem::Specification.new do |spec|
  spec.name          = "horizon_client"
  spec.version       = HorizonClient::VERSION
  spec.authors       = ["MAK IT"]
  spec.email         = ["martins.lapsa@makit.lv"]

  spec.summary       = %q{Client for Horizon accounting REST xml API.}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.0"

  spec.add_dependency 'faraday'
  spec.add_dependency 'multi_xml'
  spec.add_dependency 'faraday_middleware'
end
