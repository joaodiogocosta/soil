module Soil
  module Http
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
      end

      private def build_context(raw_context)
        Context.new(raw_context)
      end
    end
  end
end
