module Soil
  module HooksDSL
    def before_hooks
      @@before_hooks
    end

    def before(&hook : Http::Request, Http::Response ->)
      @@before_hooks << hook
    end

    def after_hooks
      @@after_hooks
    end

    def after(&hook : Http::Request, Http::Response ->)
      @@after_hooks << hook
    end
  end
end
