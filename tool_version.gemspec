# frozen_string_literal: true

require_relative "lib/tool_version/version"

Gem::Specification.new do |spec|
  spec.name = "tool_version"
  spec.version = ToolVersion::VERSION
  spec.authors = ["Liberatys"]
  spec.email = ["nick.flueckiger@renuo.ch"]

  spec.summary = "A utility gem to fetch recent versions from your git repos"
  spec.homepage = "https://github.com/Liberatys/tool_version"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Liberatys/tool_version"
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
