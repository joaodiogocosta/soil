module Soil
  module Http
    module Scheme
      HTTP  = "http"
      HTTPS = "https"
      ON = "on"
      HTTP_X_FORWARDED_SCHEME = "HTTP_X_FORWARDED_SCHEME"
      HTTP_X_FORWARDED_PROTO = "HTTP_X_FORWARDED_PROTO"
      HTTP_X_FORWARDED_HOST = "HTTP_X_FORWARDED_HOST"
      HTTP_X_FORWARDED_PORT = "HTTP_X_FORWARDED_PORT"
      HTTP_X_FORWARDED_SSL = "HTTP_X_FORWARDED_SSL"

      def self.parse(request)
        headers = request.headers

        if headers[HTTPS]? == ON
          HTTPS
        elsif headers[HTTP_X_FORWARDED_SSL]? == ON
          HTTPS
        elsif headers[HTTP_X_FORWARDED_SCHEME]?
          headers[HTTP_X_FORWARDED_SCHEME]?
        elsif headers[HTTP_X_FORWARDED_PROTO]?
          headers[HTTP_X_FORWARDED_PROTO].not_nil!.split(',')[0]
        else
          HTTP
        end
      end
    end
  end
end
