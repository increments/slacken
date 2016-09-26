module Slacken::Filters
  # Public: Reject blank elements.
  class ElimBlanks < Slacken::Filter
    def call(component)
      if component.type.member_of?(:pre)
        component
      else
        component.derive(
          component.children.reject(&method(:blank?)).map(&method(:call))
        )
      end
    end

    def valid?(component)
      if component.type.member_of?(:pre)
        true
      else
        !blank?(component) && component.children.all?(&method(:valid?))
      end
    end

    private

    def blank?(component)
      # Reduce complexity of calculation by marking.
      # (`blank?` traces the given tree to its leaf nodes.)
      return component.marks[:blank] if component.marks.has_key?(:blank)

      component.marks[:blank] =
        case component.type.name
        when :pre, :ul, :li, :br, :hr, :img, :checkbox, :td
          false
        when :text, :emoji
          content = component.attrs[:content]
          content.nil? || !content.match(/\A\n*\Z/).nil?
        else
          component.children.empty? || component.children.all?(&method(:blank?))
        end
    end
  end
end
