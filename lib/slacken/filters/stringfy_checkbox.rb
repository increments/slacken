module Slacken::Filters
  # Public: Change checkbox input node to checkbox node.
  class StringfyCheckbox < Slacken::Filter
    def call(component)
      if checkbox_input?(component)
        component.class.new(:checkbox, [], checked: component.attrs[:checked])
      else
        component.derive(component.children.map(&method(:call)))
      end
    end

    def valid?(component)
      if checkbox_input?(component)
        false
      else
        component.children.all?(&method(:valid?))
      end
    end

    private

    def checkbox_input?(component)
      component.type.member_of?(:input) && component.attrs[:type] == 'checkbox'
    end
  end
end
