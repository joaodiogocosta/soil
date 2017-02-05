module Soil
  module HooksDSL
    def before_callbacks
      @@before_callbacks
    end

    def before(&hook : Http::Request, Http::Response ->)
      @@before_callbacks << hook
    end

    def after_callbacks
      @@after_callbacks
    end

    def after(&hook : Http::Request, Http::Response ->)
      @@after_callbacks << hook
    end
  end
end
