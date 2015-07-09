module Slacken::Filters
  # Public: Remove line breaks from texts.
  class ElimLineBreaks < Slacken::Filter
    def call(component)
      case component.type.name
      when :pre
        component
      when :text
        new_content = component.attrs[:content].gsub(/[\r\n]/, '')
        component.derive(
          component.children,
          attrs: component.attrs.merge(content: new_content)
        )
      else
        component.derive(
          component.children.map(&method(:call))
        )
      end
    end

    def valid?(component)
      has_no_line_breaks?(component)
    end

    def has_no_line_breaks?(component)
      case component.type.name
      when :pre
        true
      when :text
        !component.attrs[:content].match(/[\r\n]/)
      else
        component.children.all?(&method(:has_no_line_breaks?))
      end
    end
  end
end
