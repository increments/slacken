require 'kosi'

module Slacken
  class TableElement
    def initialize(children)
      if children.first.type.name == :thead
        thead, tbody = children.slice(0, 2)
        @header = thead.child # tr tag
        @columns = tbody.children # tr tags
      else
        @header = nil
        @columns = children
      end
    end

    def render
      Kosi::Table.new(table_head).render(table_body).to_s.chomp
    end

    def to_s
      render
    end

    private

    def table_head
      @header ? { header: @header.children.map(&:to_s) } : {}
    end

    def table_body
      @columns.map { |column| column.children.map(&:to_s) }
    end
  end
end
