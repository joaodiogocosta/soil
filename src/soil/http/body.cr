module Soil
  module Http
    class BodyParams
      alias BodyType = (IO | Nil)
      property original_body : BodyType
      property json : JSON::Any?
      property text : String?

      def initialize(body : BodyType)
        @original_body = body
      end

      def json
        @json ||= parse_json
      end

      def text
        @text ||= parse_text
      end

      private def parse_json
        JSON.parse(@original_body || "null")
      rescue JSON::ParseException
        return nil_json
      end

      private def parse_text
        if !@original_body.nil?
          @original_body.to_s
        else
          nil
        end
      end

      private def nil_json
        JSON::Any.new(nil)
      end
    end
  end
end
