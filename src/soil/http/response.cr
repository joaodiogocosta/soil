module Soil
  module Http
    class Response
      def initialize(context : HTTP::Server::Context, app_class : App.class)
        @context = context
        @app_class = app_class
        @halted = false
      end

      def status(status_code : Int32)
        response.status_code = status_code
        self
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

      def redirect(resource)
        if request.version == "HTTP/1.1" && request.method != Method::GET
          response.status_code = Status::SeeOther.code
        else
          response.status_code = Status::Found.code
        end

        uri = URI.parse(resource)
        if uri.host.nil?
          uri.scheme = find_scheme
          uri.host = @app_class.configuration.host
          uri.port = @app_class.configuration.port
          uri.path = resource
        end

        response.headers["Location"] = uri.to_s
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

      private def find_scheme
        Scheme.parse(request)
      end

      forward_missing_to response
    end
  end
end
