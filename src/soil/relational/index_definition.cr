module Relational
  class IndexDefinition
    getter table_name : String | Symbol
    getter column_names
    getter name : String | Symbol
    getter unique : Bool
    property options : String?

    def initialize(table_name, column_names : Array(String), name = nil, unique = false, options = "")
      @table_name = table_name
      @column_names = column_names
      @name = resolve_name(name, table_name, column_names)
      @unique = unique
      @options = options
    end

    private def resolve_name(name, table_name, column_names)
      return name if name
      "#{table_name}_#{column_names.join("_")}"
    end
  end
end
