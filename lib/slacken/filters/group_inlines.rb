module Slacken::Filters
  # Public: Group inline elements and wrap them in a wrapper node.
  #         Wrapper nodes are introduced to group inline nodes in a paragraph.
  class GroupInlines < Slacken::Filter
    def call(component)
      if component.block?
        component.derive(group_component(component))
      else
        component.derive(component.children.map(&method(:call)))
      end
    end

    def valid?(component)
      if component.type.member_of?(:wrapper)
        true
      elsif component.inline?
        false
      else
        component.children.all?(&method(:valid?))
      end
    end

    private

    def group_component(component)
      component.children.map(&method(:call)).chunk(&:inline?).map do |is_inline, group|
        is_inline ? component.class.new(:wrapper, group) : group
      end.flatten
    end
  end
end
