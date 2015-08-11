module Slacken
  # Internal: Contain classes calculating proper spacing to serialize RenderElement.
  #
  # TODO: The class and module names are vague.
  #       Give better names to these class and module.
  module Rendering
    def self.decorate(str)
      DecorationWrapper.new(str)
    end

    # These StringWrapper and DecorationWrapper is to calculate spacing of
    # each RenderElement's string representation.
    #
    # Most formatting expression in Slack messages should have distances from neighbor strings.
    # For example, Slack does not make the following text `*should-be-bold*` bold.
    #
    #   previous-string-*should-be-bold*-next-string
    #

    # Internal: A string which may adjoin previous and next strings.
    class StringWrapper
      def self.wrap(str)
        str.kind_of?(StringWrapper) ? str : new(str)
      end

      def initialize(str)
        @str = str
      end

      def to_s
        @str.to_s
      end

      # Internal: Append another string to self.
      def append(other)
        other.concat_head(self)
      end

      # Internal: prepend another string to self.
      def concat_head(other)
        StringWrapper.new(other.to_s + to_s)
      end
    end

    # Internal: A string which should put distances from previous and next strings.
    class DecorationWrapper < StringWrapper

      # Public: Append another string to self.
      #         If the other string begin with a word character,
      #         A space is inserted between the two string.
      def append(other)
        if other.to_s.empty?
          self
        elsif other.to_s.match(/\A[\W&&[:ascii:]]/)
          other.concat_head(self)
        else
          StringWrapper.new(to_s + " ").append(other)
        end
      end

      # Private: Prepend another string to self.
      #          If the other string end with a word character,
      #          A space is inserted between the two string.
      def concat_head(other)
        if other.to_s.empty?
          self
        elsif other.to_s.match(/[\W&&[:ascii:]]\Z/)
          DecorationWrapper.new(other.to_s + to_s)
        else
          DecorationWrapper.new("#{other} #{to_s}")
        end
      end
    end

    # These classes represents gruop of strings and they concat their strings with
    # their own separator.
    # They also works with StringWrapper and DecorationWrapper to avoid
    # bad or unnecessary spacing.
    #
    # For example, Slack does not make the following text `* should-be-bold *` bold
    # because there are spaces after the first asterisk and before the last asterisk.
    #
    #   * should-be-bold *
    #
    # Besides, for such the formatting expressions, it is unnecessary to put space on
    # the beginning of each new line. Unnecessary spacing does not look good.
    #
    #   This is the first line.
    #    *This* is the second line.
    #   This is the third line.
    #

    # Internal: an intermediate object to stringfy RenderElements.
    class RenderingGroup
      attr_reader :children
      def initialize(children)
        @children = children
      end

      def separator
        fail NotImplementedError
      end

      # Internal: Return Array of Strings, where there are separators between each string.
      def to_a
        extracted_children = children.map { |c| c.respond_to?(:to_a) ? c.to_a : c }
        extracted_children.zip(Array.new(children.length, separator)).flatten[0..-2]
      end

      def to_s
        to_a.reduce(StringWrapper.new('')) { |r, el| r.append(StringWrapper.wrap(el)) }.to_s
      end
    end

    class Paragraphs < RenderingGroup
      def separator
        "\n\n"
      end
    end

    class Listings < RenderingGroup
      def separator
        "\n"
      end
    end

    class Inlines < RenderingGroup
      def separator
        ''
      end
    end
  end
end
