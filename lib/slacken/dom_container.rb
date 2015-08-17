require 'nokogiri'

module Slacken
  # Public: a DOM tree container parsed by Nokogiri.
  class DomContainer
    attr_reader :root

    def initialize(root)
      @root = root
    end

    def to_component(node = root)
      children = node.children.map { |nd| to_component(nd) }.compact
      leave(node, children)
    end

    private

    def leave(node, children)
      if !(node.respond_to?(:html_dtd?) && node.html_dtd?)
        DocumentComponent.new(node.name.downcase, children, attrs_of(node))
      end
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
