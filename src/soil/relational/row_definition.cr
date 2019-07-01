module Relational
  class RowDefinition
    getter table_name : String | Symbol
    @attributes = {} of String => DBAny

    def initialize(table_name, attributes)
      @table_name = table_name
      attributes.each do |name, value|
        @attributes[name.to_s] = value
      end
    end

    def columns
      @attributes.keys
    end

    def values
      @attributes.values
    end
  end
end
