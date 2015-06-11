require 'kosi'

module Slacken
  class TableElement
    attr_reader :header, :columns
    def initialize(children)
      thead, tbody = children.slice(0, 2)
      @header = thead.child # tr tag
      @columns = tbody.children # tr tags
    end

    def render
      head = header.children.map(&:to_s)
      body = columns.map { |cl| cl.children.map(&:to_s) }
      table = Kosi::Table.new(header: head).render(body)
      table.to_s.chomp
    end

    def to_s
      render
    end
  end
end
