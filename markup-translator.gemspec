# -*- encoding: utf-8 -*-

require File.expand_path('../lib/markup-translator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "markup-translator"
  gem.version       = MarkupTranslator::VERSION
  gem.summary       = %q{Translate HTML sources to markup texts for notification services}
  gem.description   = %q{Translate HTML sources to markup texts for notification services}
  gem.license       = "MIT"
  gem.authors       = ["Tomoya Chiba"]
  gem.email         = "tomo.asleep@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/markup-translator"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rdoc', '~> 3.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'

  gem.add_runtime_dependency 'nokogiri', '~> 1.6'
  gem.add_runtime_dependency 'kosi', '~> 1.0'
end
