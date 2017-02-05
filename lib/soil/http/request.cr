module Soil
  module Http
    class Request
      def initialize(request : HTTP::Request)
        @request = request
      end

      forward_missing_to @request
    end
  end
end
