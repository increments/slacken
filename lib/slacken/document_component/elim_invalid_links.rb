class Slacken::DocumentComponent
  module ElimInvalidLinks
    # Private: Eliminate internal links and blank links
    def elim_invalid_links
      if invalid_link?
        derive(children.map(&:elim_invalid_links), type: :span)
      else
        derive(children.map(&:elim_invalid_links))
      end
    end

    def invalid_link?
      if type.member_of?(:a)
        link = attrs[:href]
        link.nil? ||
          !link.match(%r{\Ahttps?://})
      else
        false
      end
    end

    def has_no_invalid_links?
      !invalid_link? && children.all?(&:has_no_invalid_links?)
    end
  end
end
