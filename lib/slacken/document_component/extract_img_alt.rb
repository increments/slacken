class Slacken::DocumentComponent
  module ExtractImgAlt
    def extract_img_alt
      if type.member_of?(:img)
        child = self.class.new(:text, [], content: attrs[:alt] || attrs[:src])
        derive([child])
      else
        derive(children.map(&:extract_img_alt))
      end
    end
  end
end
