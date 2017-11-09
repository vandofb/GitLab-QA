lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlab/qa/version'

Gem::Specification.new do |spec|
  spec.name          = 'gitlab-qa'
  spec.version       = Gitlab::QA::VERSION
  spec.authors       = ['Grzegorz Bizon']
  spec.email         = ['grzesiek.bizon@gmail.com']

  spec.summary       = 'Integration tests for GitLab'
  spec.homepage      = 'http://about.gitlab.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`
                       .split("\x0").reject { |f| f.match(%r{^spec/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '~> 12.2'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rubocop', '~> 0.51'
end
