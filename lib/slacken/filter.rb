module Slacken
  # Public: Base class of filters for DocumentComponent.
  class Filter
    attr_reader :options
    def initialize(options = {})
      @options = options
    end

    # Public: Create a new refined DocumentComponent from the given component.
    #
    # component - A DocumentComponent object.
    #
    # Returns a new refined DocumentComponent object.
    def call(component)
      fail NotImplementedError
    end

    # Public: Check if the given component passes postcondition of the filter.
    #
    # component - A DocumentComponent object to check.
    #
    # Returns true if the component passes the postcondition.
    def valid?(component)
      true
    end
  end
end
