require 'active_support'

module Lantern
  module Embeddings
    extend ActiveSupport::Concern

    class_methods do
      # Generates a text embedding using the specified model
      #
      # @param model [String] The embedding model to use (e.g., 'BAAI/bge-base-en')
      # @param text [String] The text input to embed
      # @return [Array<Float>] The generated embedding vector
      def text_embedding(model, text)
        generate_embedding(model, text, 'text_embedding')
      end
      def openai_embedding(model, text, dim = nil)
        Lantern.ensure_token!(:openai)
        generate_embedding(model, text, 'openai_embedding', dim)
      end
      def cohere_embedding(model, text, input_type = nil)
        Lantern.ensure_token!(:cohere)
        generate_embedding(model, text, 'cohere_embedding', input_type)
      end

      private

      def generate_embedding(model, text, embedding_function, other = nil)
        sanitized_model = connection.quote(model)
        sanitized_text = connection.quote(text)
        if other
          query = "SELECT #{embedding_function}(#{sanitized_model}, #{sanitized_text}, #{other}) AS embedding"
        else
          query = "SELECT #{embedding_function}(#{sanitized_model}, #{sanitized_text}) AS embedding"
        end
        result = connection.select_one(query)
        embedding = result['embedding'].tr('{}', '').split(',').map(&:to_f)
        embedding
      end
    end
  end
end
  