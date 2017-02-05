module Soil
  class Route
    getter method : String
    getter path : String
    getter callables = [] of Action | (Http::Request, Http::Response ->)

    def initialize(@method, @path, callables)
      @callables += callables
    end

    def matches?(method, path)
      (method == @method) && (path == @path)
    end

    def call(request, response)
      @callables.each &.call(request, response)
    end
  end
end
