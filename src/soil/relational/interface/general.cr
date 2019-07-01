module Relational
  module Interface
    module General
      extend self

      # Inserts a new row a table
      #
      # ```
      # insert(:users)
      # ```
      def insert(table_name, row_attributes = {} of String => DBAny)
        row = RowDefinition.new(table_name, row_attributes)
        Database.exec dialect.insert(row), row.values
      end

      private def dialect
        Relational.config.dialect
      end
    end
  end
end
