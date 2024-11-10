require_relative 'lantern/version'
require_relative 'lantern/model'
require_relative 'lantern/embeddings'
require 'active_support'

module Lantern
  class Error < StandardError; end

  extend Lantern::Embeddings::ClassMethods

  class << self
    def connection
      ActiveRecord::Base.connection
    end
  end
end

ActiveSupport.on_load(:active_record) do
  extend Lantern::Model
end

require_relative 'lantern/railtie' if defined?(Rails::Railtie)
