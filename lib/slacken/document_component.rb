require 'forwardable'
require 'slacken/filters'

module Slacken
  # Public: An intermediate object that is used when a HTML source is translated into a MarkupElement
  #         representing structure of a markup text.
  #         A DocumentComponent has tree structure and has child nodes as `children`.
  class DocumentComponent
    NORMALIZE_FILTERS = [
      Filters::StringfyEmoji,
      Filters::StringfyCheckbox,
      Filters::ExtractImgAlt,
      Filters::ElimInvalidLinks,
      Filters::SanitizeHeadline,
      Filters::SanitizeLink,
      Filters::SanitizeList,
      Filters::SanitizeTable,
      Filters::GroupInlines,
      Filters::GroupIndent,
      Filters::ElimBlanks,
      Filters::ElimLineBreaks,
    ]

    extend Forwardable
    def_delegators :@type, :block?, :inline?

    attr_reader :type, :attrs, :children, :marks

    # Public: Parse a html source with nokogiri and create a component.
    #
    # html_source - A String or IO.
    #
    # Returns a DocumentComponent or nil.
    def self.build_by_html(html_source)
      DomContainer.new(Nokogiri::HTML(html_source)).to_component
    end

    def initialize(type, children = [], attrs = {})
      @type = NodeType.create(type)
      @attrs = attrs
      @children = children
      @marks = {}
    end

    def derive(new_children, updates = {})
      self.class.new(
        updates[:type] || type,
        new_children,
        updates[:attrs] || attrs
      )
    end

    # Public: Normalize this object's structure and convert it to MarkupElement.
    def to_element
      normalize.produce_element
    end

    def normalize
      NORMALIZE_FILTERS.reduce(self) do |component, filter_klass|
        filter_klass.new.call(component)
      end
    end

    def produce_element
      if type.member_of?(:table)
        TableElement.new(children.map(&:produce_element))
      else
        RenderElement.new(type, children.map(&:produce_element), attrs)
      end
    end

    def ==(another)
      type == another.type &&
      attrs_comp = attrs.sort == another.attrs.sort &&
      children == another.children
    end
  end
end
