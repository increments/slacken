module Slacken::Filters
  # Public: Sanitize not allowed tags in table.
  class SanitizeTable < Slacken::Filter
    def call(component)
      if component.type.member_of?(:table)
        component.derive(component.children.map(&method(:sanitize_table)))
      else
        component.derive(component.children.map(&method(:call)))
      end
    end

    def valid?(component)
      if component.type.member_of?(:table)
        component.children.all?(&method(:table_sanitized?))
      else
        component.children.all?(&method(:valid?))
      end
    end

    private

    def sanitize_table(component)
      if component.type.allowed_in_table?
        component.derive(
          component.children.map(&method(:sanitize_table))
        )
      else
        # No block tags are allowed.
        component.derive(
          component.children.map(&method(:sanitize_table)),
          type: :span
        )
      end
    end

    def table_sanitized?(component)
      if component.type.allowed_in_table?
        component.children.all?(&method(:table_sanitized?))
      else
        false
      end
    end
  end
end
