# -*- encoding: utf-8 -*-

require File.expand_path('../lib/slacken/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "slacken"
  gem.version       = Slacken::VERSION
  gem.summary       = %q{Translate HTML sources to markup texts for slack}
  gem.description   = %q{Translate HTML sources to markup texts for slack}
  gem.license       = "MIT"
  gem.authors       = ["Tomoya Chiba", "Yuku Takahashi"]
  gem.email         = ["tomo.asleep@qiita.com", "yuku@qiita.com"]
  gem.homepage      = "https://rubygems.org/gems/slacken"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rdoc', '~> 3.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'unindent', '~> 1.0'

  gem.add_runtime_dependency 'nokogiri', '~> 1.6'
  gem.add_runtime_dependency 'kosi', '~> 1.0'
end
