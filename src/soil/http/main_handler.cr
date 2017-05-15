module Soil
  module Http
    module Handlers
      class MainHandler
        include HTTP::Handler

        def initialize(app_class : App.class)
          @app_class = app_class
        end

        def call(raw_context)
          context = build_context(raw_context)
          @app_class
            .find(context.request)
            .call(context.request, context.response)

          call_next(raw_context) unless context.response.halted?
        end

        private def build_context(raw_context)
          Context.new(raw_context, @app_class)
        end
      end
    end
  end
end
