module Relational
  module Dialects
    #:nodoc:
    class Postgres < Abstract
      DATA_TYPES = {
        "string"      => "character varying",
        "datetime"    => "timestamp",
        "binary"      => "bytea",
        "bit_varying" => "bit varying"
      }

      # Creates a table
      #
      # Output:
      # ```
      # CREATE TABLE table_name (
      #   column_name1 column_type1,
      #   column_name2 column_type2
      #   ...
      # )
      # ```
      def create_table(table_definition)
        if table_definition.default_id
          table_definition.column(
            :id,
            :serial,
            options: "PRIMARY KEY"
          )
        end
        super
      end

      # Changes a column
      #
      # Output:
      # ```
      # ALTER TABLE
      #   table_name
      # ALTER COLUMN column_name TYPE column_type
      # ```
      def change_column(table_name, column_definition)
        String.build do |io|
          io << "ALTER TABLE "
          io << table_name
          io << " ALTER COLUMN "
          io << column_definition.name
          io << " TYPE "
          io << find_data_type(column_definition.data_type)
        end
      end

      # Removes an index if it exists
      #
      # Output:
      # ```
      # DROP INDEX IF EXISTS index_name
      # ```
      def remove_index(name)
        "DROP INDEX IF EXISTS #{name}"
      end

      def table_exists?(name)
        String.build do |io|
          io << "SELECT EXISTS ("
          io << "SELECT 1 "
          io << "FROM information_schema.tables "
          io << "WHERE table_name = '#{name}'"
          io << ")"
        end
      end

      def as_prepared(values)
        i = 0
        values.map do |value|
          i += 1
          "$#{i}"
        end
      end

      protected def find_data_type(name)
        DATA_TYPES[name.to_s]? || super
      end
    end
  end
end
