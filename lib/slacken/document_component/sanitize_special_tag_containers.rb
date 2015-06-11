class Slacken::DocumentComponent
  module SanitizeSpecialTagContainers
    # Private: Sanitize not allowed tags in list, headline, and table.
    def sanitize_special_tag_containers
      # NOTE: each special tag (list, headline, and table) is not allowed to occur
      #       in another type special tags.
      case type.name
      when /h\d/
        derive(children.map(&:sanitize_headline))
      when :ul, :ol, :dl
        derive(children.map(&:sanitize_list))
      when :table
        derive(children.map(&:sanitize_table))
      else
        derive(children.map(&:sanitize_special_tag_containers))
      end
    end

    def sanitize_headline
      if type.allowed_in_headline?
        derive(children.map(&:sanitize_headline))
      else
        # No block tags are allowed.
        derive(children.map(&:sanitize_headline), type: :span)
      end
    end

    def sanitize_list
      if type.member_of?(:li, :dd)
          head, *tails = children
          derive([head.sanitize_list_item, *tails.map(&:sanitize_list)])
      elsif type.allowed_in_list?
        derive(children.map(&:sanitize_list))
      else
        derive(children.map(&:sanitize_list), type: block? ? :div : :span)
      end
    end

    def sanitize_list_item
      if type.allowed_as_list_item?
        derive(children.map(&:sanitize_list_item))
      else
        # No block tags are allowed.
        derive(children.map(&:sanitize_list_item), type: :span)
      end
    end

    def sanitize_table
      if type.allowed_in_table?
        derive(children.map(&:sanitize_table))
      else
        # No block tags are allowed.
        derive(children.map(&:sanitize_table), type: :span)
      end
    end

    def sanitized?
      case type.name
      when /h\d/
        children.all?(&:headline_sanitized?)
      when :ul, :ol, :dl
        children.all?(&:list_sanitized?)
      when :table
        children.all?(&:table_sanitized?)
      else
        children.all?(&:sanitized?)
      end
    end

    def headline_sanitized?
      if type.allowed_in_headline?
        children.all?(&:headline_sanitized?)
      else
        false
      end
    end

    def list_sanitized?
      if type.allowed_in_list?
        children.all?(&:list_sanitized?)
      else
        false
      end
    end

    def list_item_sanitized?
      if type.allowed_as_list_item?
        children.all?(&:list_item_sanitized?)
      else
        false
      end
    end

    def table_sanitized?
      if type.allowed_in_table?
        children.all?(&:table_sanitized?)
      else
        false
      end
    end
  end
end
