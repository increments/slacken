module MarkupTranslator
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

    def to_s
      case type.name
      when :text
        attrs[:content]
      when :emoji
        " #{attrs[:content]} "
      when :checkbox
        attrs[:checked] ? '[x] ' : '[ ] '
      when :b, :strong
        " *#{inner.strip}* "
      when :i, :em
        " _#{inner.strip}_ "
      when :iframe, :a
        SlackUrl.link_tag(inner, attrs[:href])
      when :img
        SlackUrl.link_tag(attrs[:alt], attrs[:src])
      when :pre
        "```#{inner}```"
      when :blockquote
        insert_head(inner, '> ')
      when :code
        " `#{inner}` "
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
        insert_head(inner)
      when /h\d/
        "*#{inner.strip}*"
      else
        inner
      end
    end

    def itemize
      children.map.with_index(1) do |child, idx|
        mark = type.member_of?(:ol) ? "#{idx}. " : '• '
        "#{mark}#{child}"
      end.join(separator)
    end

    def inner
      children.map(&:to_s).join(separator)
    end

    def separator
      if type.inline?
        ''
      elsif type.member_of?(:ul, :ol, :dl, :li, :dd, :dt)
        "\n"
      elsif type.block?
        # Each block node is treated as one paragraph.
        "\n\n"
      end
    end

    def insert_head(str, head = ' ' * 4)
      str.gsub(/^/, head)
    end
  end
end
