module Slacken::Filters
  # Public: Sanitize not allowed tags in links.
  class SanitizeLink < Slacken::Filter
    def call(component)
      if component.type.member_of?(%i(img a iframe))
        component.derive(
          component.children.map(&method(:sanitize))
        )
      else
        component.derive(
          component.children.map(&method(:call))
        )
      end
    end

    def valid?(component)
      if component.type.member_of?(%i(img a iframe))
        component.children.all?(&method(:link_containers_sanitized?))
      else
        component.children.all?(&method(:valid?))
      end
    end

    private

    def sanitize(component)
      if component.type.allowed_in_link?
        component.derive(
          component.children.map(&method(:sanitize))
        )
      else
        # No block tags are allowed.
        component.derive(
          component.children.map(&method(:sanitize)),
          type: :span
        )
      end
    end

    def link_containers_sanitized?(component)
      if component.type.allowed_in_link?
        component.children.all?(&method(:link_containers_sanitized?))
      else
        false
      end
    end
  end
end
