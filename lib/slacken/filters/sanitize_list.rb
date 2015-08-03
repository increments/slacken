module Slacken::Filters
  # Public: Sanitize not allowed tags in list.
  class SanitizeList < Slacken::Filter
    def call(component)
      case component.type.name
      when :ul, :ol, :dl
        component.derive(component.children.map(&method(:sanitize_list)))
      else
        component.derive(component.children.map(&method(:call)))
      end
    end

    def valid?(component)
      case component.type.name
      when :ul, :ol, :dl
        component.children.all?(&method(:list_sanitized?))
      else
        component.children.all?(&method(:valid?))
      end
    end

    private

    def sanitize_list(component)
      if component.type.member_of?(:li, :dd)
          head, *tails = component.children
          component.derive(
            [sanitize_list_item(head), *tails.map(&method(:sanitize_list))]
          )
      elsif component.type.allowed_in_list?
        component.derive(component.children.map(&method(:sanitize_list)))
      else
        component.derive(
          component.children.map(&method(:sanitize_list)),
          type: block? ? :div : :span
        )
      end
    end

    def sanitize_list_item(component)
      if component.type.allowed_as_list_item?
        component.derive(component.children.map(&method(:sanitize_list_item)))
      else
        # No block tags are allowed.
        component.derive(component.children.map(&method(:sanitize_list_item)), type: :span)
      end
    end

    def list_sanitized?(component)
      if component.type.allowed_in_list?
        component.children.all?(&method(:list_sanitized?))
      else
        false
      end
    end
  end
end
