module Soil
  module Views
    module View
      private macro compile_template(template_path)
        String.build do |__template__|
          ECR.embed({{ template_path.id.stringify }}, "__template__")
        end
      end

      private macro compile_template(template_path, layout = nil)
        yield_contents = compile_template({{ template_path.id.stringify }}).strip
        compile_template {{ layout.id.stringify }}
      end

      macro render_template(io, template_path)
        io << compile_template {{ template_path }}
      end

      macro render_template(io, template_path, layout = nil)
        io << compile_template {{ template_path }}, {{ layout }}
      end

      abstract def render(io : IO)

      def render
        result = String.build { |io| render(io) }
        result.strip
      end
    end
  end
end
