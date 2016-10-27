module Slacken::Filters
  # Public: Convert emoji image nodes to emoji nodes.
  class StringfyEmoji < Slacken::Filter
    def call(component)
      if emoji_img_tag?(component)
        emoji_code = component.attrs[:alt]
        emoji_code = $~[:emoji_code] if emoji_code.match(/^:(?<emoji_code>.+):$/)
        component.class.new(:emoji, [], content: emoji_code)
      else
        component.derive(component.children.map(&method(:call)))
      end
    end

    def valid?(component)
      if emoji_img_tag?(component)
        false
      else
        component.children.all?(&method(:valid?))
      end
    end

    private

    def emoji_img_tag?(component)
      component.type.member_of?(:img) && component.attrs[:class].include?('emoji')
    end
  end
end
