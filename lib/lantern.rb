require_relative 'lantern/version'

module Lantern
  class Error < StandardError; end
end

require_relative 'lantern/railtie' if defined?(Rails::Railtie)
