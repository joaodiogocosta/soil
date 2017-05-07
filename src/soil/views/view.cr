module Soil
  module Views
    module View
      macro template(path_to_file)
        ECR.def_to_s("{{ path_to_file.id }}")
      end

      # Override required to remove '\n' from the end of file
      def to_s
        super.strip
      end
    end
  end
end
