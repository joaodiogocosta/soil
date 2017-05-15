module Soil
  module Http
    class Context
      def initialize(context : HTTP::Server::Context, app_class : App.class)
        @context = context
        @app_class = app_class
      end

      def request
        @request ||= Request.new(@context)
      end

      def response
        @response ||= Response.new(@context, @app_class)
      end
    end
  end
end
