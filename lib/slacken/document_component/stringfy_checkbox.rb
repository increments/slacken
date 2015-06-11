class Slacken::DocumentComponent
  module StringfyCheckbox
    # Private: Reject blank elements
    def stringfy_checkbox
      if type.member_of?(:input) && attrs[:type] == 'checkbox'
        self.class.new(:checkbox, [], checked: attrs[:checked])
      else
        derive(children.map(&:stringfy_checkbox))
      end
    end

    def checkbox_stringfied?
      if type.member_of?(:input) && attrs[:type] == 'checkbox'
        false
      else
        children.all?(&:checkbox_stringfied?)
      end
    end
  end
end
