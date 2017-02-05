module Soil
  module Http
    class Context
      def initialize(context : HTTP::Server::Context)
        @context = context
      end

      def request
        @request ||= Request.new(@context.request)
      end

      def response
        @response ||= Response.new(@context.response)
      end
    end
  end
end
