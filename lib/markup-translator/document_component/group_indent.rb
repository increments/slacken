class MarkupTranslator::DocumentComponent
  module GroupIndent
    # Private: Wrap contents to indent.
    #          Childrens of li or dd tags are wrapped.
    def group_indent
      if type.member_of?(:li, :dd)
        head, *tails = children.map(&:group_indent)
        derive([head, self.class.new(:indent, tails)])
      else
        derive(children.map(&:group_indent))
      end
    end

    def indent_grouped?
      if type.member_of?(:li, :dd)
        head, tail = children
        if tail
          tail.type.member_of?(:indent) && tail.indent_grouped?
        else
          true
        end
      else
        children.all?(&:indent_grouped?)
      end
    end
  end
end
