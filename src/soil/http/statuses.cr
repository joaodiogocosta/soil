module Soil
  module Http
    module Status
      extend self

      macro define_status(code, name, message)
        module {{ name.id }}
          extend self

          def code
            {{ code.id }}
          end

          def message
            {{ message.id.stringify }}
          end
        end
      end

      define_status 200, "Ok", "Ok"
      define_status 302, "Found", "Found"
      define_status 303, "SeeOther", "See Other"
      define_status 404, "NotFound", "Not Found"
    end
  end
end
