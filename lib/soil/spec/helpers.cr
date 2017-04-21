module Soil
  module Spec
    module RouteHelpers
      def build_route(method, path, handlers = [] of Handler)
        Soil::Route.new(method, path, handlers)
      end

      def build_example_request(method, path, host = "http://example.org")
        resource = host + path
        Soil::Http::Request.new(
          HTTP::Request.new(method, resource)
        )
      end

      def build_example_response
        Soil::Http::Response.new(
          HTTP::Server::Response.new(IO::Memory.new)
        )
      end

      def build_handler(&block ->)
        first_handler = Proc(Http::Request, Http::Response, Nil).new do |_, _|
          block.call
          nil
        end
      end
    end
  end
end
