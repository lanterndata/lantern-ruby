# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

# Define a simple Rake task for running all PostgreSQL tests
Rake::TestTask.new do |t|
  t.description = 'Run all tests'
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
end

# Set the default task to run the test task
task default: :test
