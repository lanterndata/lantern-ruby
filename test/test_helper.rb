require 'simplecov'
require 'simplecov-cobertura'
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
SimpleCov.start

require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "active_record"
require "dotenv/load"

ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])
ActiveRecord::Base.connection.enable_extension("lantern")

def assert_elements_in_delta(expected, actual)
  assert_equal expected.size, actual.size
  expected.zip(actual) do |exp, act|
    assert_in_delta exp, act
  end
end
