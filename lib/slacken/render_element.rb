module Slacken
  class RenderElement
    attr_reader :type, :renderer, :attrs, :children

    def initialize(type, children = [], attrs = {})
      @type = NodeType.create(type)
      @attrs = attrs
      @children = children
    end

    def child
      children.first
    end

    def render
      case type.name
      when :text
        attrs[:content]
      when :emoji
        deco "#{attrs[:content]}"
      when :checkbox
        deco (attrs[:checked] ? '[x]' : '[ ]')
      when :b, :strong
        deco "*#{inner.to_s.strip}*"
      when :i, :em
        deco "_#{inner.to_s.strip}_"
      when :iframe, :a
        deco SlackUrl.link_tag(inner, attrs[:href])
      when :img
        deco SlackUrl.link_tag(attrs[:alt], attrs[:src])
      when :pre
        deco "```#{inner}```"
      when :blockquote
        insert_head(inner.to_s, '> ')
      when :code
        deco "`#{inner}`"
      when :br
        "\n"
      when :hr
        '-----------'
      when :li, :dd
        # Item mark is appended by the parent list tag.
        inner
      when :ol, :ul, :dl
        itemize
      when :indent
        insert_head(inner.to_s)
      when /h\d/
        "*#{inner.to_s.strip}*"
      else
        inner
      end
    end

    def to_s
      render.to_s
    end

    private

    def itemize
      children_strs = children.map.with_index(1) do |child, idx|
        mark = type.member_of?(:ol) ? "#{idx}. " : '• '
        "#{mark}#{child}"
      end
      grouping(children_strs)
    end

    def inner
      grouping(children.map(&:render))
    end

    def grouping(children_strs)
      if type.inline?
        Rendering::Inlines.new(children_strs)
      elsif type.member_of?(:ul, :ol, :dl, :li, :dd, :dt)
        Rendering::Listings.new(children_strs)
      elsif type.block?
        Rendering::Paragraphs.new(children_strs)
      end
    end

    def insert_head(str, head = ' ' * 4)
      str.gsub(/^/, head)
    end

    def deco(str)
      Rendering.decorate(str)
    end
  end
end
