module Soil
  module Http
    module ContentTypes
      extend self

      macro define_content_type(name, value)
        def {{ name.id }}
          {{ value.id.stringify }}
        end
      end

      define_content_type "json", "application/json"
      define_content_type "text", "text/plain"
    end
  end
end
