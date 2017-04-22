module Soil
  class Router
    getter routes

    def initialize
      @routes = [] of Route
    end

    def add(method, path, callables)
      @routes << Route.new(method, format_path(path), callables)
    end

    # TODO: it would be great to have an option for a custom
    # matcher passed by the user. Eventually a class or a lambda
    # or both
    def find(request)
      found = @routes.find do |route|
        route.matches?(request)
      end
      found || nil_route
    end

    private def nil_route
      Route.new("", "", [NilAction.new])
    end

    private def format_path(path)
      path.lchop("/").chomp("/").insert(0, "/")
    end
  end
end
