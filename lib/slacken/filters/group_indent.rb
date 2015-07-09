module Slacken::Filters
  # Public: Wrap child content nodes of each li or dd node with an indent node.
  class GroupIndent < Slacken::Filter
    def call(component)
      if component.type.member_of?(%i(li dd))
        head, *tails = component.children.map(&method(:call))
        component.derive([head, component.class.new(:indent, tails)])
      else
        component.derive(
          component.children.map(&method(:call))
        )
      end
    end

    def valid?(component)
      if component.type.member_of?(%i(li dd))
        head, tail = component.children
        if tail
          tail.type.member_of?(:indent) && valid?(tail)
        else
          true
        end
      else
        component.children.all?(&method(:valid?))
      end
    end
  end
end
