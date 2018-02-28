module Slacken::Filters
  # Public: Replace unsupported images by placeholder.
  class ReplaceUnsupportedImgs < Slacken::Filter
    def call(component)
      if img_with_data_uri?(component)
        component.class.new(
          :text, [], content: '&lt;img src="data:..."&gt;'
        )
      else
        component.derive(
          component.children.map(&method(:call)),
        )
      end
    end

    private

    def img_with_data_uri?(component)
      component.type.member_of?(:img) &&
        (component.attrs[:src] || '') =~ /^data:/i
    end
  end
end
