module Slacken
  module Rendering
    def self.decorate(str)
      DecorationWrapper.new(str)
    end

    # Private: A wrapper of string to concat node strings of a document tree.
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

      # Public: Append another string to self.
      def append(other)
        other.concat_head(self)
      end

      # Private: prepend another string to self.
      def concat_head(other)
        StringWrapper.new(other.to_s + to_s)
      end
    end

    # Private: A wrapper to space before and after the given string.
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

    # Public: an intermediate object to stringfy RenderElements.
    #
    class RenderingGroup
      attr_reader :children
      def initialize(children)
        @children = children
      end

      def separator
        fail NotImplementedError
      end

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
