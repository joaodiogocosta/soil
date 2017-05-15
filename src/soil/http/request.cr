module Soil
  module Http
    class Request
      getter params : Params

      def initialize(context : HTTP::Server::Context)
        @context = context
        @params = Params.parse(@context.request)
      end

      forward_missing_to @context.request
    end
  end
end
