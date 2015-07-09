module Slacken
  class Filter
    attr_reader :options
    def initialize(options = {})
      @options = options
    end

    def call(component)
      fail NotImplementedError
    end

    def valid?(component)
      true
    end
  end
end
