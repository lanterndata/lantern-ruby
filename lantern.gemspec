require_relative 'lib/lantern/version'

Gem::Specification.new do |spec|
  spec.name          = 'lantern'
  spec.version       = Lantern::VERSION
  spec.author       =  'Di Qi'
  spec.email         = 'support@lantern.dev'
  spec.summary       = 'Lantern Rails Client'
  spec.homepage      = 'https://lantern.dev'
  spec.license       = 'MIT'
  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => 'https://github.com/lanterndata/lantern-ruby',
    'bug_tracker_uri' => 'https://github.com/lanterndata/lantern-ruby/issues',
    'documentation_uri' => 'https://lantern.dev/docs',
    'changelog_uri' => 'https://github.com/lanterndata/lantern-ruby/blob/main/CHANGELOG.md'
  }
  spec.files = Dir.glob('lib/**/*') + ['LICENSE.txt', 'README.md']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_path = 'lib'
  spec.required_ruby_version = ">= 3.1"
  spec.add_dependency 'activerecord', '>= 7.0'
  spec.add_dependency 'activesupport', '>= 7.0'
  spec.add_dependency 'pg', '>= 1.2'
  spec.add_development_dependency 'dotenv', '>= 2.7'
  spec.add_development_dependency 'minitest', '>= 5.14'
  spec.add_development_dependency 'rake', '>= 13.0'
  spec.add_development_dependency 'rubocop', '>= 1.0'
  spec.add_development_dependency 'railties', '>= 7.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-cobertura'
end
