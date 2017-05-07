module Soil
  module Http
    class Response
      def initialize(response : HTTP::Server::Response)
        @response = response
      end

      def html(str)
        @response.content_type = Soil::Http::ContentTypes.html
        @response << str
      end

      def json(object)
        @response.content_type = Soil::Http::ContentTypes.json
        object.to_json(@response)
      end

      def text(object)
        @response.content_type = Soil::Http::ContentTypes.text
        object.to_s(@response)
      end

      def render(view_klass, data)
        @response.content_type = Soil::Http::ContentTypes.html
        view_klass.new(data).to_s(@response)
      end

      forward_missing_to @response
    end
  end
end
