# frozen_string_literal: true

require_relative "lib/justifi/version"

Gem::Specification.new do |spec|
  spec.name = "justifi"
  spec.version = Justifi::VERSION
  spec.authors = ["JustiFi"]
  spec.email = ["support@justifi.ai"]

  spec.summary = "JustiFi API wrapper gem"
  spec.description = "Used to communicate with JustiFi APIs"
  spec.homepage = "https://justifi.ai"
  spec.required_ruby_version = ">= 2.4"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/justifi-tech/justifi-ruby"
  spec.metadata["github_repo"] = "ssh://github.com/justifi-tech/justifi-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/justifi-tech/justifi-ruby/changelog"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features|gem)/}) }
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "webmock", ">= 3.8.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-small-badge"
end
