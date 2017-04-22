module Soil
  module ConfigDSL
    def configure(&block)
      yield @@config
    end
  end
end
