# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'local_gov_code/version'

Gem::Specification.new do |spec|
  spec.name          = "local_gov_code"
  spec.version       = LocalGovCode::VERSION
  spec.authors       = ["Hideo NAKAMURA"]
  spec.email         = ["cxn03651@msj.biglobe.ne.jp"]

  spec.summary       = %q{全国地方公共団体コードを取り扱うgemです。平成26年4月5日現在データによります。}
  spec.description   = %q{全国地方公共団体コードを取り扱うgemです。平成26年4月5日現在データによります。}
  spec.homepage      = "http://github.com/cxn03651/local_gov_code#readme"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
