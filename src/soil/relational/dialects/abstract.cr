module Relational
  module Dialects
    #:nodoc:
    abstract class Abstract
      # Creates a table
      #
      # ```
      # CREATE TABLE table_name (
      #   column_name1 column_type1
      #   column_name2 column_type2
      #   ...
      # )
      # ```
      def create_table(table_definition)
        columns = table_definition.columns.flat_map do |column|
          [
            column.name,
            find_data_type(column.data_type),
            column.options
          ].compact.join(" ")
        end

        String.build do |io|
          io << "CREATE TABLE "
          io << table_definition.name
          io << " ("
          io << columns.join(", ")
          io << ")"
        end
      end

      def drop_table(name)
        "DROP TABLE IF EXISTS #{name}"
      end

      # Changes a column
      #
      # Output:
      # ```
      # ALTER TABLE
      #   table_name
      # ADD
      #   column_name column_type
      # ```
      def add_column(table_name, column_definition)
        String.build do |io|
          io << "ALTER TABLE "
          io << table_name
          io << " ADD "
          io << column_definition.name
          io << " "
          io << find_data_type(column_definition.data_type)
          io << " #{column_definition.options}" if column_definition.options
        end
      end

      # Removes a column if it exists
      #
      # Output:
      # ```
      # ALTER TABLE
      #   table_name
      # DROP COLUMN
      #   column_name
      # ```
      def remove_column(table_name, column_name)
        String.build do |io|
          io << "ALTER TABLE "
          io << table_name
          io << " DROP COLUMN "
          io << column_name
        end
      end

      # Output:
      #
      # ```
      # CREATE [UNIQUE] INDEX [CONCURRENTLY]
      #   index_name
      # ON table_name
      # (
      #   column_name1,
      #   column_name2,
      #   ...
      # )
      #
      # ```
      def add_index(index)
        String.build do |io|
          io << "CREATE "
          io << "UNIQUE " if index.unique
          io << "INDEX "
          io << index.name
          io << " ON "
          io << index.table_name
          io << "("
          io << index.column_names.join(",")
          io << ")"
        end
      end

      # Inserts a row
      #
      # Output:
      # ```
      # INSERT INTO
      #   table_name
      # (
      #   column1,
      #   column2,
      #   ...
      # )
      # VALUES
      # (
      #   value1,
      #   value2
      # )
      # ```
      def insert(row)
        sql = String.build do |io|
          io << "INSERT INTO "
          io << row.table_name
          io << " ("
          io << row.columns.join(",")
          io << ") "
          io << "VALUES ("
          io << as_prepared(row.values).join(",")
          io << ")"
        end
      end

      abstract def as_prepared(values)
      abstract def remove_index(*args)
      abstract def remove_index(*args)
      abstract def table_exists?(name)
      abstract def change_column(*args)

      protected def find_data_type(name)
        name
      end
    end
  end
end
