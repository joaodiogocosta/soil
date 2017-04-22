module Soil
  module Http
    class Request
      getter params

      def initialize(request : HTTP::Request)
        @request = request
        @params = {} of String => String
      end

      forward_missing_to @request
    end
  end
end
