# frozen_string_literal: true

require_relative "lib/monkey_lens/version"

Gem::Specification.new do |spec|
  spec.name = "monkey_lens"
  spec.version = MonkeyLens::VERSION
  spec.authors = ["Matthew Looney"]
  spec.email = ["theworker02@users.noreply.github.com"]

  spec.summary = "Audit monkey patches and Ruby runtime method drift"
  spec.description = "MonkeyLens captures method ownership, source locations, signatures, visibility, and ancestor order for selected Ruby classes and modules, then detects runtime drift against a committed baseline."
  spec.homepage = "https://github.com/theworker02/monkeylens"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/theworker02/monkeylens/issues",
    "changelog_uri" => "https://github.com/theworker02/monkeylens/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://theworker02.github.io/monkeylens/",
    "funding_uri" => "https://github.com/sponsors/theworker02",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir.chdir(__dir__) do
    Dir["{lib,exe,sig,assets}/**/*", "CHANGELOG.md", "LICENSE.txt", "README.md"].select { |path| File.file?(path) }
  end
  spec.bindir = "exe"
  spec.executables = ["monkeylens"]
  spec.require_paths = ["lib"]
end
