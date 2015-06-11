require 'forwardable'

require 'slacken/document_component/elim_blanks'
require 'slacken/document_component/elim_invalid_links'
require 'slacken/document_component/elim_line_breaks'
require 'slacken/document_component/extract_img_alt'
require 'slacken/document_component/group_inlines'
require 'slacken/document_component/group_indent'
require 'slacken/document_component/sanitize_link_containers'
require 'slacken/document_component/sanitize_special_tag_containers'
require 'slacken/document_component/stringfy_checkbox'
require 'slacken/document_component/stringfy_emoji'

# Public: An intermediate object that is used when a HTML source is translated into a MarkupElement
#         representing structure of a markup text.
#         A DocumentComponent has tree structure and has child nodes as `children`.
module Slacken
  class DocumentComponent
    include ElimBlanks
    include ElimInvalidLinks
    include ElimLineBreaks
    include ExtractImgAlt
    include GroupInlines
    include GroupIndent
    include SanitizeLinkContainers
    include SanitizeSpecialTagContainers
    include StringfyCheckbox
    include StringfyEmoji

    extend Forwardable
    def_delegators :@type, :block?, :inline?

    attr_reader :type, :attrs, :children

    def initialize(type, children = [], attrs = {})
      @type = NodeType.create(type)
      @attrs = attrs
      @children = children
    end

    def derive(new_children, updates = {})
      self.class.new(
        updates[:type] || type, new_children, updates[:attrs] || attrs)
    end

    # Public: Normalize this object's structure and convert it to MarkupElement.
    def to_element
      normalize.produce_element
    end

    def normalize
      stringfy_emoji
        .stringfy_checkbox
        .extract_img_alt
        .elim_invalid_links
        .sanitize_link_containers
        .sanitize_special_tag_containers
        .group_inlines
        .group_indent
        .elim_blanks
        .elim_line_breaks
    end

    # Private: Convert this element to a MarkupElement.
    def produce_element
      if type.member_of?(:table)
        TableElement.new(children.map(&:produce_element))
      else
        RenderElement.new(type, children.map(&:produce_element), attrs)
      end
    end
  end
end
