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

          if has_next_handler? && !context.response.halted?
            call_next(raw_context)
          end
        end

        private def build_context(raw_context)
          Context.new(raw_context, @app_class)
        end

        private def has_next_handler?
          !!@next
        end
      end
    end
  end
end
