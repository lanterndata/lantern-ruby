module Lantern
  module Model
    def has_neighbors(*attribute_names)
      attribute_names.map!(&:to_sym)

      scope :nearest_neighbors, ->(attribute_name, vector) {
        attribute_name = attribute_name.to_sym

        unless vector.all? { |v| v.is_a?(Integer) }
            vector = vector.map(&:to_f)
        end

        vector_literal = vector.join(',')
        order_expression = "#{quoted_table_name}.#{connection.quote_column_name(attribute_name)} <-> ARRAY[#{vector_literal}]"

        select_columns = select_values.any? ? [] : column_names
        select(select_columns, "#{order_expression} AS distance")
          .where.not(attribute_name => nil)
          .order(Arel.sql(order_expression))
      }

      define_method :nearest_neighbors do |attribute_name|
        attribute_name = attribute_name.to_sym
        self.class
          .where.not(id: id)
          .nearest_neighbors(attribute_name, self[attribute_name])
      end
    end
  end
end