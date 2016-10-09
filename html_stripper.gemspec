# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'html_stripper/version'

Gem::Specification.new do |spec|
  spec.name          = 'html_stripper'
  spec.version       = HtmlStripper::VERSION
  spec.authors       = ['jkr2255']
  spec.email         = ['jkr2255@users.noreply.github.com']

  spec.summary       = 'Strips comments and unnecessary whitespaces from HTML.'
  spec.homepage      = 'https://github.com/jkr2255/html_stripper'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
                                        .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0.0'
  spec.add_dependency 'ice_nine', '~> 0.11'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.43'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'sinatra', '~> 1.4'
end
