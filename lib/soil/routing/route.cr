module Soil
  class Route
    getter method : String
    getter path : String
    getter callables = [] of Action | (String ->)

    def initialize(@method, @path, callables = [] of Action | (String ->))
      @callables += callables
    end

    def matches?(method, path)
      (method == @method) && (path == @path)
    end

    def call(context : String)
      @callables.each &.call(context)
    end
  end
end
