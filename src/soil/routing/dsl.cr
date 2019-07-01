module Soil
  module RoutingDSL
    macro define_http_method(verb)
      # Empty paths
      def {{ verb.id.downcase }}(&handler : Http::Request, Http::Response ->)
        {{ verb.id.downcase }}("", &handler)
      end

      def {{ verb.id.downcase }}(handler : Action)
        {{ verb.id.downcase }}("", handler)
      end

      def {{ verb.id.downcase }}(handlers : Array(Handler))
        {{ verb.id.downcase }}("", handlers)
      end

      # With paths
      def {{ verb.id.downcase }}(path, &handler : Http::Request, Http::Response ->)
        mount_route({{ verb.upcase }}, path.to_s, [handler])
      end

      def {{ verb.id.downcase }}(path, handler : Action)
        mount_route({{ verb.upcase }}, path.to_s, [handler])
      end

      def {{ verb.id.downcase }}(path, handlers : Array(Handler))
        mount_route({{ verb.upcase }}, path.to_s, handlers)
      end
    end

    define_http_method "get"
    define_http_method "post"

    def mount(mountable_class : App.class)
      mount("", mountable_class)
    end

    def mount(path, mountable_class : App.class)
      mountable_class.routes.each do |route|
        mount_route(route.method, path.to_s + route.path, route.callables)
      end
    end
  end
end
