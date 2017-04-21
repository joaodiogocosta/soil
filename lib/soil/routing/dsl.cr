module Soil
  module RoutingDSL
    def get(path : String, &handler : Http::Request, Http::Response ->)
      mount_route("GET", path, [handler])
    end

    def get(path : String, handler : Action)
      mount_route("GET", path, [handler])
    end

    def get(path : String, handlers : Array(Handler))
      mount_route("GET", path, handlers)
    end

    def post(path : String, &handler : Http::Request, Http::Response ->)
      mount_route("POST", path, [handler])
    end

    def post(path : String, handler : Action)
      mount_route("POST", path, [handler])
    end

    def post(path : String, handlers : Array(Handler))
      mount_route("GET", path, handlers)
    end

    def mount(path : String, mountable_class : App.class)
      mountable_class.routes.each do |route|
        mount_route(route.method, path + route.path, route.callables)
      end
    end
  end
end
