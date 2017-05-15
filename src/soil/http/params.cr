module Soil
  module Http
    class Params
      property query : Hash(String, String)?

      def self.parse(request : HTTP::Request)
        instance = new(request)
      end

      def initialize(request : HTTP::Request)
        @request = request
      end

      def body
        @body ||= BodyParams.new(@request.body)
      end

      def form
        @form ||= HTTP::Params.parse(@request.body.not_nil!.gets_to_end)
      end

      def query
        @query ||= @request.query_params.to_h
      end

      def url
        @url ||= {} of String => String
      end
    end
  end
end
