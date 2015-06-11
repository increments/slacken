class Slacken::DocumentComponent
  module ElimLineBreaks
    # Private: Reject blank elements
    def elim_line_breaks
      case type.name
      when :text
        new_content = attrs[:content].gsub(/[\r\n]/, ' ')
        derive(children, attrs: attrs.merge(content: new_content))
      when :pre
        self
      else
        derive(children.map(&:elim_line_breaks))
      end
    end

    def has_no_line_breaks?
      case type.name
      when :text
        !attrs[:content].match(/[\r\n]/)
      when :pre
        true
      else
        children.all?(&:has_no_line_breaks?)
      end
    end
  end
end
