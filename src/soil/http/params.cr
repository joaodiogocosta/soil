module Soil
  module Http
    class Params
      property body : BodyParams
      property query = {} of String => String
      property url

      def self.parse(request : HTTP::Request)
        instance = new(request)
      end

      def initialize(request : HTTP::Request)
        @body = BodyParams.new(request.body)
        @query = request.query_params.to_h
        @url = {} of String => String
      end
    end
  end
end
