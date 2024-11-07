require_relative "lib/lantern/version"

Gem::Specification.new do |spec|
  spec.name          = "lantern"
  spec.version       = Lantern::VERSION
  spec.authors       = ["Di Qi"]
  spec.email         = ["support@lantern.dev"]
  spec.summary       = "Lantern Ruby Clients"
  spec.description   = "Lantern Ruby Clients including ActiveRecord, pg, and Sequel."
  spec.homepage      = "https://lantern.dev"
  spec.license       = "MIT"
  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/lanterndata/lantern-ruby",
    "bug_tracker_uri" => "https://github.com/lanterndata/lantern-ruby/issues",
    "documentation_uri" => "https://lantern.dev/docs",
    "changelog_uri" => "https://github.com/lanterndata/lantern-ruby/blob/main/CHANGELOG.md"
  }
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "activerecord", ">= 7.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "pg", "~> 1.5"
end
