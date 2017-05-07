module Soil
  module Http
    class Response
      def initialize(response : HTTP::Server::Response)
        @response = response
      end

      def json(object)
        @response.content_type = Soil::Http::ContentTypes.json
        object.to_json(@response)
      end

      def text(object)
        @response.content_type = Soil::Http::ContentTypes.text
        object.to_s(@response)
      end

      forward_missing_to @response
    end
  end
end
