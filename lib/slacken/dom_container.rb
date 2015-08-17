require 'nokogiri'

module Slacken
  # Public: a DOM tree container parsed by Nokogiri.
  class DomContainer
    def initialize(root)
      @root = root
    end

    # Public: Create a DocumentComponent of the root node.
    #
    # Returns a DocumentComponent or nil.
    def to_component
      build_document_component(@root)
    end

    private

    # Internal: Build a DocumentComponent of the given node recursively.
    #
    # current_node - A Nokogiri::HTML::Document.
    #
    # Returns a DocumentComponent.
    def build_document_component(node)
      DocumentComponent.new(
        node.name.downcase,
        build_document_components_array(node.children),
        attrs_of(node)
      )
    end

    # Internal: Build sequence of DocumentComponent objects for each given nodes.
    #
    # nodes - A Nokogiri::XML::NodeSet.
    #
    # Returns an Array of DocumentComponents.
    def build_document_components_array(node_set)
      node_set
        .reject { |node| node.respond_to?(:html_dtd?) && node.html_dtd? }
        .map { |node| build_document_component(node) }
    end

    def attrs_of(node)
      case node.name.to_sym
      when :text
        { content: node.content }
      when :iframe, :a
        { href: node['href'] }
      when :input
        { type: node['type'], checked: node['checked'] }
      when :img
        { src: node['src'], alt: node['alt'], class: (node['class'] || '').split }
      else
        {}
      end
    end
  end
end
