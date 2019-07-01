module Relational
  module Dialects
    #:nodoc:
    class Null < Abstract
      def change_column(*args)
        ""
      end

      def remove_index(*args)
        ""
      end

      def table_exists?(*args)
        ""
      end

      def as_prepared(*args)
        [] of String
      end
    end
  end
end
