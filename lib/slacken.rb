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
    def translate(html_source)
      convert(html_source).to_s
    end

    private

    def convert(html_source)
      Slacken::DomContainer.parse_html(html_source)
        .to_component.to_element
    end
  end
end
