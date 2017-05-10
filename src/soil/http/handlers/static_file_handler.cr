module Soil
  module Http
    module Handlers
      class StaticFileHandler < HTTP::StaticFileHandler
        def initialize(@public_dir : String, @fallthrough = true, @enabled = false)
        end

        def call(context)
          return call_next(context) unless !!@enabled
          return call_next(context) if context.request.path == "/"
          super(context)
        end
      end
    end
  end
end
