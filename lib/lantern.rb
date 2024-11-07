require "lantern/version"
require "lantern/railtie" if defined?(Rails)

module Lantern
  class Error < StandardError; end
  
  # Add extension-related functionality
  def self.install
    ActiveRecord::Base.connection.enable_extension 'lantern'
  rescue StandardError => e
    raise Error, "Failed to enable Lantern extension: #{e.message}"
  end
  
  # You can add future functionality here, such as:
  # - Vector index creation helpers
  # - Vector query methods
  # - Configuration options
end