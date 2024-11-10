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
      def generate_embedding(model, text)
        sanitized_model = connection.quote(model)
        sanitized_text = connection.quote(text)
        result = connection.select_one("SELECT text_embedding(#{sanitized_model}, #{sanitized_text}) AS embedding")
        embedding = result['embedding'].tr('{}', '').split(',').map(&:to_f)
        embedding
      end
    end
  end
end
  