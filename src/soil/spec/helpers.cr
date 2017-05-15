module Soil
  module Spec
    module RouteHelpers
      include Http

      DEFAULT_METHOD = Method::GET
      DEFAULT_PATH = "/"
      DEFAULT_HOST = "http://example.org"

      class ExampleApp < Soil::App; end

      def build_route(method, path, handlers = [] of Handler)
        Soil::Route.new(method, path, handlers)
      end

      def build_request(method, path)
        uri = URI.parse(path)
        context = build_raw_context do |ctx|
          ctx.request.method = method
          ctx.request.path = uri.path
          ctx.request.query = uri.query
        end
        Request.new(context)
      end

      def build_raw_request(method = DEFAULT_METHOD, url = DEFAULT_PATH)
        uri = URI.parse(url)
        HTTP::Request.new(method, uri.full_path)
      end

      def build_response(io = IO::Memory.new)
        build_response(io) {}
      end

      def build_response(io = IO::Memory.new)
        context = build_raw_context(io: io)
        app = ExampleApp
        yield(context, app)
        Response.new(context, app)
      end

      def build_raw_response(io = IO::Memory.new)
        HTTP::Server::Response.new(io)
      end

      def build_raw_context(io = IO::Memory.new)
        build_raw_context(io) {}
      end

      def build_raw_context(io = IO::Memory.new)
        context = HTTP::Server::Context.new(
          build_raw_request,
          build_raw_response(io)
        )
        yield(context)
        context
      end

      def build_handler(&block)
        Proc(Request, Response, Nil).new do |_, _|
          block.call
          nil
        end
      end
    end
  end
end
