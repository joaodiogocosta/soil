module Soil
  module RoutingDSL
    def get(path : String, &block : String ->)
      mount_route("get", "/", [block])
    end

    def get(path : String, action : Action)
      mount_route("get", "/", [action])
    end

    def post(path : String, &block : String ->)
      mount_route("post", "/", [block])
    end

    def post(path : String, action : Action)
      mount_route("post", "/", [action])
    end

    def mount(path : String, mountable_class : App.class)
      mountable_class.routes.each do |route|
        mount_route(route.method, path + route.path, route.callables)
      end
    end
  end
end
