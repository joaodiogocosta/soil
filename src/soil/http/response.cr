module Soil
  module Http
    class Response
      def initialize(response : HTTP::Server::Response)
        @response = response
      end

      def json(object)
        object.to_json(@response)
      end

      forward_missing_to @response
    end
  end
end
