# Public: Provide DSL methods to build a DocumentComponent like S-exp.
module DocumentComponentDsl
  def c(type_name, *children)
    options = children.first.is_a?(Hash) ? children.shift : {}
    MarkupTranslator::DocumentComponent.new(type_name, children, options)
  end

  def text(content)
    MarkupTranslator::DocumentComponent.new(:text, [], content: content)
  end
end
