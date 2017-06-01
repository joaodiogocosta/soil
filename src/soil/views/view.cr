module Soil
  module Views
    module View
      include Templating::Macros

      abstract def render(io : IO)

      def render
        String.build do |io|
          render(io)
        end
      end
    end
  end
end
