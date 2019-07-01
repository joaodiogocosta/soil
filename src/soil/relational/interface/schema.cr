module Relational
  module Interface
    module Schema
      extend self

      # Creates a table
      #
      # ```
      # create_table(:users) do |t|
      #   t.column :name, :string, "PRIMARY KEY"
      # end
      # ```
      def create_table(name, id = true)
        table_definition = TableDefinition.new(name, default_id = !!id)
        yield table_definition
        Database.exec dialect.create_table(table_definition)
      end

      # Drops a table
      #
      # ``` # drop_table(:users)
      # ```
      def drop_table(name)
        Database.exec dialect.drop_table(name)
      end

      # Adds a column to a table
      #
      # ```
      # add_column(:users, :name)
      # ```
      def add_column(table_name, column_name, data_type)
        column_definition = ColumnDefinition.new(column_name, data_type)
        Database.exec dialect.add_column(table_name, column_definition)
      end

      # Removes a column from a table
      #
      # ```
      # remove_column(:users, :name)
      # ```
      def remove_column(table_name, column_name)
        Database.exec dialect.remove_column(table_name, column_name)
      end

      # Changes a column
      #
      # ```
      # change_column(:users, :biography, :text)
      # ```
      def change_column(table_name, column_name, data_type)
        column_definition = ColumnDefinition.new(column_name, data_type)
        Database.exec dialect.change_column(table_name, column_definition)
      end


      def add_index(table_name, column_name, **args)
        add_index(table_name, [column_name.to_s], **args)
      end

      # Creates an index for multiple_columns
      #
      # ```
      # add_index(:users, [:username, :email])
      # ```
      def add_index(table_name, column_names : Array(String), name = nil, unique = false)
        index_definition = IndexDefinition.new(
          table_name,
          column_names,
          name: name,
          unique: unique
        )
        Database.exec dialect.add_index(index_definition)
      end

      def remove_index(table_name, column_name)
        remove_index(table_name, [column_name.to_s])
      end

      def remove_index(table_name, column_names : Array(Symbol | String))
        remove_index(table_name, column_names.map(&:to_s))
      end

      def remove_index(table_name, column_names : Array(Symbol))
        remove_index(table_name, column_names.map(&:to_s))
      end

      def remove_index(table_name, column_names : Array(String))
        index = IndexDefinition.new(table_name, column_names)
        Database.exec dialect.remove_index(index.name)
      end

      # Returns true if a table exists and false otherwise
      #
      # ```
      # table_exists?("users")
      # ```
      def table_exists?(name)
        Database.scalar dialect.table_exists?(name)
      end

      # Removes an index
      #
      # ```
      # remove_index("users_id")
      # ```
      def remove_index(name)
        Database.exec dialect.remove_index(name)
      end

      private def dialect
        Relational.config.dialect
      end
    end
  end
end
