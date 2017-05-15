module Soil
  module Http
    class Response
      def initialize(context : HTTP::Server::Context, app_class : App.class)
        @context = context
        @app_class = app_class
        @halted = false
      end

      def html(text)
        response.content_type = Soil::Http::ContentTypes.html
        response << text
      end

      def json(object)
        response.content_type = Soil::Http::ContentTypes.json
        object.to_json(response)
      end

      def text(object)
        response.content_type = Soil::Http::ContentTypes.text
        object.to_s(response)
      end

      def render(view_klass, *data)
        response.content_type = Soil::Http::ContentTypes.html
        view_klass.new(*data).render(response)
      end

      def redirect(path)
        if request.version == "HTTP/1.1" && request.method != Method::GET
          response.status_code = Status::SeeOther.code
        else
          response.status_code = Status::Found.code
        end
        response.headers["Location"] = build_url(path)
        halt!
      end

      def halted?
        @halted
      end

      def halt!
        @halted = true
      end

      private def response
        @context.response
      end

      private def request
        @context.request
      end

      private def build_url(path)
        URI.new(
          scheme: find_scheme,
          host: @app_class.configuration.host,
          port: @app_class.configuration.port,
          path: path
        ).to_s
      end

      private def find_scheme
        Scheme.parse(request)
      end

      forward_missing_to response
    end
  end
end
