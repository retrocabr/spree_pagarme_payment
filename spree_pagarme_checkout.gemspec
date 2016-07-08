# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spree_pagarme_payment/version'

Gem::Specification.new do |spec|
  spec.name          = "spree_pagarme_payment"
  spec.version       = SpreePagarmePayment::VERSION
  spec.authors       = ["Denise Fugihara"]
  spec.email         = ["denise@retroca.com.br"]
  spec.summary       = %q{A Spree extension to apply Pagarme (pagar.me) payment method.}
  spec.description   = %q{Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.0.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'pagarme'
  spec.add_dependency 'spree_core', '~> 3.1.0'
  spec.add_dependency 'spree_gateway', '~> 3.1.0'
  spec.add_dependency 'spree_auth_devise', '~> 3.1.0'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'coffee-rails'
  spec.add_development_dependency 'rspec-rails',  '~> 2.9'
  spec.add_development_dependency 'sass-rails'
  spec.add_development_dependency 'sqlite3'
end
