# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "rspec-http-fixtures"
  spec.version = "0.1.0"
  spec.authors = ["James Hu"]

  spec.summary = "Capistrano plugin for deploying and managing Nomad jobs"
  spec.description = "Capistrano plugin for deploying and managing Nomad jobs"
  spec.homepage = "https://github.com/axsuul/rspec-http-fixtures"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/axsuul/rspec-http-fixtures"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    %x(git ls-files -z).split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency("byebug")
  spec.add_dependency("rake")

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
