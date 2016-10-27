module Slacken
  # Public: Representing type of DocumentComponent.
  class NodeType
    def self.create(name)
      name.is_a?(NodeType) ? name : new(name)
    end

    attr_reader :name
    def initialize(name)
      @name = name.to_sym
    end

    def member_of?(*names)
      names.flatten.include?(name)
    end

    def text_types
      %i(text emoji checkbox)
    end

    def block?
      member_of?(%i(document div iframe p img ul ol dl dd li hr indent
                    p h1 h2 h3 h4 h5 h6 h7 h8 pre blockquote body html))
    end

    def inline?
      !block?
    end

    def text_type?
      member_of?(text_types)
    end

    def allowed_in_list?
      member_of?(%i(emoji code b strong i em wrapper div indent span ol ul dl li dd dt).concat(text_types))
    end

    def allowed_as_list_item?
      member_of?(%i(emoji code b strong i em wrapper span).concat(text_types))
    end

    def allowed_in_headline?
      member_of?(%i(emoji i em wrapper span).concat(text_types))
    end

    def allowed_in_table?
      member_of?(%i(emoji code b strong i em wrapper span thead tbody tr th td).concat(text_types))
    end

    def allowed_in_link?
      member_of?(%i(emoji b strong i em wrapper span).concat(text_types))
    end

    def ==(another)
      name == another.name
    end
  end
end
