require_relative 'lantern/version'
require_relative 'lantern/model'
require_relative 'lantern/embeddings'
require 'active_support'

module Lantern
  class Error < StandardError; end
  class MissingTokenError < StandardError; end

  extend Lantern::Embeddings::ClassMethods

  class << self
    def connection
      ActiveRecord::Base.connection
    end

    def current_user
      connection.select_value("SELECT CURRENT_USER")
    end

    def set_api_token(openai_token: nil, cohere_token: nil)
      if openai_token
        connection.execute("ALTER ROLE #{current_user} SET lantern_extras.openai_token = #{connection.quote(openai_token)};")
      end
      if cohere_token
        connection.execute("ALTER ROLE #{current_user} SET lantern_extras.cohere_token = #{connection.quote(cohere_token)};")
      end
      connection.execute("SELECT pg_reload_conf();")
    end

    def openai_token
      connection.select_value("SHOW lantern_extras.openai_token")
    end

    def cohere_token
      connection.select_value("SHOW lantern_extras.cohere_token")
    end

    def ensure_token!(provider)
      case provider
      when :openai
        raise MissingTokenError, "OpenAI token is required for OpenAI embedding generation" if openai_token.blank?
      when :cohere
        raise MissingTokenError, "Cohere token is required for Cohere embedding generation" if cohere_token.blank?
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  extend Lantern::Model
end

require_relative 'lantern/railtie' if defined?(Rails::Railtie)
