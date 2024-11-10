module Lantern
  module Model
    def has_neighbors(*attribute_names)
      attribute_names.map!(&:to_sym)

      scope :nearest_neighbors, ->(attribute_name, vector_or_text, model: nil, openai_dim: nil, cohere_input_type: nil, distance: 'l2') {
        attribute_name = attribute_name.to_sym

        # Distance operator
        distance_operators = {
          'l2' => '<->',
          'cosine' => '<=>'
        }
        operator = distance_operators[distance]
        unless operator
          raise ArgumentError, "Invalid distance metric. Allowed metrics are #{distance_operators.keys.join(', ')}"
        end

        # Vector order by expression
        order_expression = "#{quoted_table_name}.#{connection.quote_column_name(attribute_name)} #{operator}" + if model
          # Generate vector from text
          text = vector_or_text
          embedding_function = case model
                               when /^openai/ then 'openai_embedding'
                               when /^cohere/ then 'cohere_embedding'
                               else 'text_embedding'
                               end
          other = model.start_with?('openai') ? openai_dim : model.start_with?('cohere') ? cohere_input_type : nil
          sanitized_model = connection.quote(model)
          sanitized_text = connection.quote(text)
          if other
            "#{embedding_function}(#{sanitized_model}, #{sanitized_text}, #{other})"
          else
            "#{embedding_function}(#{sanitized_model}, #{sanitized_text})"
          end
        else
          # Vector-based search
          vector = vector_or_text
          unless vector.all? { |v| v.is_a?(Integer) }
            vector = vector.map(&:to_f)
          end
          vector_literal = vector.join(',')
          "ARRAY[#{vector_literal}]"
        end

        select_columns = select_values.any? ? [] : column_names
        select(select_columns, "#{order_expression} AS distance")
          .where.not(attribute_name => nil)
          .order(Arel.sql(order_expression))
      }

      define_method :nearest_neighbors do |attribute_name, distance: 'l2'|
        attribute_name = attribute_name.to_sym
        self.class
          .where.not(id: id)
          .nearest_neighbors(attribute_name, self[attribute_name], distance: distance)
      end
    end
  end
end