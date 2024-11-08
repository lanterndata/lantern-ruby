require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "active_record"
require "dotenv/load"

ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])

ActiveRecord::Base.connection.enable_extension("lantern")