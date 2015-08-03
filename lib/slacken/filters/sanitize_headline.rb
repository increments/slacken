module Slacken::Filters
  # Public: Sanitize not allowed tags in headline.
  class SanitizeHeadline < Slacken::Filter
    def call(component)
      # NOTE: each special tag (list, headline, and table) is not allowed to occur
      #       in another type special tags.
      if component.type.name =~ /h\d/
        component.derive(component.children.map(&method(:sanitize_headline)))
      else
        component.derive(component.children.map(&method(:call)))
      end
    end

    def valid?(component)
      if component.type.name =~ /h\d/
        component.children.all?(&method(:headline_sanitized?))
      else
        component.children.all?(&method(:valid?))
      end
    end

    private

    def sanitize_headline(component)
      if component.type.allowed_in_headline?
        component.derive(
          component.children.map(&method(:sanitize_headline))
        )
      else
        # No block tags are allowed.
        component.derive(
          component.children.map(&method(:sanitize_headline)),
          type: :span
        )
      end
    end

    def headline_sanitized?(component)
      if component.type.allowed_in_headline?
        component.children.all?(&method(:headline_sanitized?))
      else
        false
      end
    end
  end
end
