module MarkupTranslator
  require 'markup-translator/document_component'
  require 'markup-translator/render_element'
  require 'markup-translator/rendering'
  require 'markup-translator/nokogiri_parser'
  require 'markup-translator/node_type'
  require 'markup-translator/slack_url'
  require 'markup-translator/table_element'
  require 'markup-translator/version'

  class << self
    def translate(html_source)
      convert(html_source).to_s
    end

    def convert(html_source)
      MarkupTranslator::NokogiriParser.parse_html(html_source)
        .to_component.to_element
    end
  end
end
