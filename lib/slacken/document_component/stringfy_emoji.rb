class Slacken::DocumentComponent
  module StringfyEmoji
    # Private: Reject blank elements
    def stringfy_emoji
      if type.member_of?(:img) && attrs[:class].include?('emoji')
        self.class.new(:emoji, [], content: attrs[:alt])
      else
        derive(children.map(&:stringfy_emoji))
      end
    end

    def emoji_stringfied?
      if type.member_of?(:img) && attrs[:class].include?('emoji')
        false
      else
        children.all?(&:emoji_stringfied?)
      end
    end
  end
end
