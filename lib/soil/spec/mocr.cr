module Soil
  module Spec
    module Mocr
      class Double
        def initialize
          @calls = {} of String => Int32
        end

        def received?(method_name)
          method_name = method_name.to_s
          @calls[method_name] && @calls[method_name] > 0
        end

        macro method_missing(call)
          method_name = {{ call.name.id.stringify }}
          @calls[method_name] ||= 0
          @calls[method_name] += 1
        end
      end

      module Spy
        extend self

        @@calls = 0

        def call
          @@calls += 1
        end

        def calls
          @@calls
        end

        def called?
          @@calls > 0
        end

        def reset
          @@calls = 0
        end
      end
    end
  end
end
