# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'require_callbacks/version'

Gem::Specification.new do |spec|
  spec.name          = 'require_callbacks'
  spec.version       = RequireCallbacks::VERSION
  spec.authors       = ['smudge']
  spec.email         = ['nathan@ngriffith.com']
  spec.summary       = <<-END.gsub("\n", ' ').gsub!(/[[:space:]]+/, ' ').strip
    Convenient hooks to help prevent loading unnecessary gems and
    configuration code.
  END
  spec.description   = <<-END.gsub("\n", ' ').gsub!(/[[:space:]]+/, ' ').strip
    This gem gives you convenient hooks around calls to `load`, `require`, and
    `require_relative`, which can be used to define configuration or setup code
    that will eventually be run when the library is actually loaded. This helps
    prevent loading unnecessary gems and configuration code in contexts where
    they are not needed.
  END
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
