module Relational
  class ColumnDefinition
    getter name : String | Symbol
    getter data_type : String | Symbol
    property options : String?

    def initialize(name, data_type, options = "")
      @name = name
      @data_type = data_type
      @options = options
    end
  end
end
