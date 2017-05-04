module Soil
  module Spec
    module RouteHelpers
      def build_route(method, path, handlers = [] of Handler)
        Soil::Route.new(method, path, handlers)
      end

      def build_request(method, path, host = "http://example.org")
        resource = host + path
        Soil::Http::Request.new(
          HTTP::Request.new(method, resource)
        )
      end

      def build_raw_request(method, path, host = "http://example.org")
        resource = host + path
        HTTP::Request.new(method, resource)
      end

      def build_response
        Soil::Http::Response.new(
          HTTP::Server::Response.new(IO::Memory.new)
        )
      end

      def build_raw_context(method = "get", path = "")
        url = "http://example.org/#{path}"
        HTTP::Server::Context.new(
          HTTP::Request.new(method, url),
          HTTP::Server::Response.new(IO::Memory.new)
        )
      end

      def build_handler(&block)
        Proc(Http::Request, Http::Response, Nil).new do |_, _|
          block.call
          nil
        end
      end
    end
  end
end
