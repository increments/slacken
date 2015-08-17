module Slacken
  require 'slacken/document_component'
  require 'slacken/dom_container'
  require 'slacken/render_element'
  require 'slacken/rendering'
  require 'slacken/node_type'
  require 'slacken/slack_url'
  require 'slacken/table_element'
  require 'slacken/version'

  class << self
    # Public: Translate HTML string into Markdown string.
    #
    # html_source - A String or IO.
    #
    # Returns a markdown String.
    def translate(html_source)
      if (component = convert_html_to_document_component(html_source))
        component.to_element.to_s
      else
        ''
      end
    end

    private

    # Internal: Parse a HTML string and convert it to a DocumentComponent object.
    #
    # Returns a DocumentComponent or nil.
    def convert_html_to_document_component(html_source)
      DocumentComponent.build_by_html(html_source)
    end
  end
end
