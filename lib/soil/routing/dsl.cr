module Soil
  module RoutingDSL
    def get(path : String, &block : Http::Request, Http::Response ->)
      mount_route("GET", "/", [block])
    end

    def get(path : String, action : Action)
      mount_route("GET", "/", [action])
    end

    def post(path : String, &block : Http::Request, Http::Response ->)
      mount_route("POST", "/", [block])
    end

    def post(path : String, action : Action)
      mount_route("POST", "/", [action])
    end

    def mount(path : String, mountable_class : App.class)
      mountable_class.routes.each do |route|
        mount_route(route.method, path + route.path, route.callables)
      end
    end
  end
end
