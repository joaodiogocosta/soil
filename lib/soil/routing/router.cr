module Soil
  class Router
    getter routes

    def initialize
      @routes = [] of Route
    end

    def add(method, path, callables = [] of Action | (String ->))
      @routes << Route.new(method, format_path(path), callables)
    end

    def find(method, path)
      found = @routes.find do |route|
        route.matches?(method, path.chomp("/"))
      end
      found || nil_action
    end

    def nil_action
      ->(context : String) { p "not found" }
    end

    def format_path(path)
      path.lchomp("/").chomp("/").insert(0, "/")
    end
  end
end
