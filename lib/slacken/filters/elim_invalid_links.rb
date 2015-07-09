module Slacken::Filters
  # Public: Eliminate internal links and blank links.
  class ElimInvalidLinks < Slacken::Filter
    def call(component)
      if invalid_link?(component)
        component.derive(
          component.children.map(&method(:call)),
          type: :span
        )
      else
        component.derive(
          component.children.map(&method(:call)),
        )
      end
    end

    def valid?(component)
      return false if invalid_link?(component)
      component.children.all?(&method(:valid?))
    end

    private

    def invalid_link?(component)
      if component.type.member_of?(:a)
        link = component.attrs[:href]
        link.nil? || !link.match(%r{\Ahttps?://})
      else
        false
      end
    end
  end
end
