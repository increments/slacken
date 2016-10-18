require 'kosi'

module Slacken
  class TableElement
    attr_reader :children

    def initialize(children)
      @children = children
    end

    def render
      Kosi::Table.new(table_head).render(table_body).to_s.chomp
    end

    def to_s
      render
    end

    private

    def table_head
      header ? { header: header.children.map(&:to_s) } : {}
    end

    def table_body
      columns.map { |column| column.children.map(&:to_s) }
    end

    def header
      first_child = children.first
      if first_child.type.name == :thead
        first_child.child
      else
        nil
      end
    end

    def columns
      if header
        tbody = children[1]
        if tbody
          tbody.children
        else
          []
        end
      else
        children
      end
    end
  end
end
