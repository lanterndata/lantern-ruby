require 'bundler/setup'
require 'lantern'
require 'rails'
require 'active_record'
require 'dotenv/load'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
