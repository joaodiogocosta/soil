module Soil
  module Http
    class Request
      getter params : Params

      def initialize(request : HTTP::Request)
        @request = request
        @params = Params.parse(request)
      end

      forward_missing_to @request
    end
  end
end
