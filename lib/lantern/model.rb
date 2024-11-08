module Lantern
  module Model
    def has_neighbors(*attribute_names)
      attribute_names.map!(&:to_sym)

      scope :nearest_neighbors, ->(attribute_name, vector, distance: 'l2') {
        attribute_name = attribute_name.to_sym

        unless vector.all? { |v| v.is_a?(Integer) }
            vector = vector.map(&:to_f)
        end
        vector_literal = vector.join(',')

        distance_operators = {
          'l2' => '<->',
          'cosine' => '<=>'
        }
        operator = distance_operators[distance]
        unless operator
          raise ArgumentError, "Invalid distance metric. Allowed metrics are #{distance_operators.keys.join(', ')}"
        end

        order_expression = "#{quoted_table_name}.#{connection.quote_column_name(attribute_name)} #{operator} ARRAY[#{vector_literal}]"

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