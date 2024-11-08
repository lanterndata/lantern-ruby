require_relative 'lantern/version'
require_relative 'lantern/model'
require 'active_support'

module Lantern
  class Error < StandardError; end
end

ActiveSupport.on_load(:active_record) do
  extend Lantern::Model
end

require_relative 'lantern/railtie' if defined?(Rails::Railtie)
