class Slacken::DocumentComponent
  module SanitizeLinkContainers
    # Private: Sanitize not allowed tags in links.
    def sanitize_link_containers
      case type.name
      when :img, :a, :iframe
        derive(children.map(&:sanitize_in_link))
      else
        derive(children.map(&:sanitize_link_containers))
      end
    end

    def sanitize_in_link
      if type.allowed_in_link?
        derive(children.map(&:sanitize_in_link))
      else
        # No block tags are allowed.
        derive(children.map(&:sanitize_in_link), type: :span)
      end
    end

    def link_sanitized?
      case type.name
      when :img, :a, :iframe
        children.all?(&:list_containers_sanitized?)
      else
        children.all?(&:link_sanitized?)
      end
    end

    def link_container_sanitized?
      if type.allowed_in_link?
        children.all?(&:link_containers_sanitized?)
      else
        false
      end
    end

  end
end
