module Slacken::Filters
  # Public: Convert alt attribute of img node to child text node.
  class ExtractImgAlt < Slacken::Filter
    def call(component)
      if component.type.member_of?(:img)
        component.derive([
          component.class.new(
            :text, [], content: component.attrs[:alt] || component.attrs[:src]
          )
        ])
      else
        component.derive(
          component.children.map(&method(:call))
        )
      end
    end
  end
end
