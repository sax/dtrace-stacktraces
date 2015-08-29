# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dtrace/stacktraces/version'

Gem::Specification.new do |spec|
  spec.name          = 'dtrace-stacktraces'
  spec.version       = Dtrace::Stacktraces::VERSION
  spec.authors       = ['Eric Saxby']
  spec.email         = ['sax@livinginthepast.org']
  spec.summary       = %q{Provide Ruby stack traces to DTrace}
  spec.description   = %q{Prove Ruby stack traces to DTrace}
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.extensions    = %w(ext/dtrace/stacktraces/extconf.rb)

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib ext)

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
end
