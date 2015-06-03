class MarkupTranslator::DocumentComponent
  module GroupInlines
    # Private: Group inline elements and wrap them in a wrapper node.
    #          Wrapper nodes are introduced to group inline nodes in a paragraph.
    def group_inlines
      if block?
        new_children = children.map(&:group_inlines).chunk(&:inline?).map do |is_inline, group|
          is_inline ? self.class.new(:wrapper, group) : group
        end.flatten
        derive(new_children)
      else
        derive(children.map(&:group_inlines))
      end
    end

    def inlines_grouped?
      if type.member_of?(:wrapper)
        true
      elsif inline?
        false
      else
        children.all?(&:inlines_grouped?)
      end
    end
  end
end
