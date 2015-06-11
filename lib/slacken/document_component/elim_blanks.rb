class Slacken::DocumentComponent
  module ElimBlanks
    # Private: Reject blank elements
    def elim_blanks
      case type.name
      when :pre
        self
      else
        derive(children.reject(&:blank?).map(&:elim_blanks))
      end
    end

    def blank?
      return @is_blank if !@is_blank.nil?
      @is_blank =
        case type.name
        when :pre, :ul, :li, :br, :hr, :img, :checkbox
          false
        when :text, :emoji
          content = attrs[:content]
          content.nil? || !content.match(/\A\s*\Z/).nil?
        else
          children.empty? || children.all?(&:blank?)
        end
    end

    def has_no_blanks?
      case type.name
      when :pre
        true
      else
        !blank? && children.all?(&:has_no_blanks?)
      end
    end
  end
end
