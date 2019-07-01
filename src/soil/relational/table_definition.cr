module Relational
  class TableDefinition
    getter name : String | Symbol
    getter columns
    getter default_id

    def initialize(name, default_id = true)
      @name = name
      @columns = [] of ColumnDefinition
      @default_id = default_id
    end

    def column(name, data_type, options = nil)
      definition = ColumnDefinition.new(name, data_type, options: options)
      columns << definition
    end
  end
end
