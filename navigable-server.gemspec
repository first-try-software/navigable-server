require_relative 'lib/navigable/server/version'

Gem::Specification.new do |spec|
  spec.name          = "navigable-server"
  spec.version       = Navigable::Server::VERSION
  spec.authors       = ["Alan Ridlehoover", "Fito von Zastrow"]
  spec.email         = ["navigable@firsttry.software"]

  spec.summary       = %q{Ahoy! Welcome aboard Navigable!}
  spec.description   = %q{A Rack-based server for building Ruby and Navigable web applications.}
  spec.homepage      = "https://firsttry.software"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/first-try-software/navigable-server"
  spec.metadata["changelog_uri"] = "https://github.com/first-try-software/navigable-server/issues"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|assets)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'json', '~> 2.3'
  spec.add_dependency 'navigable', '~> 1.5'
  spec.add_dependency 'navigable-router', '~>0.2'
  spec.add_dependency 'rack', '~> 2.2'
  spec.add_dependency 'rack-abstract-format', '~> 0.9.9'
  spec.add_dependency 'rack-accept-media-types', '~> 0.9'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~>0.4"
  spec.add_development_dependency "simplecov", "~>0.17.0"
end
