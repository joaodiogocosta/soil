require "./hooks_dsl"

module Soil
  class App
    extend HooksDSL
    extend RoutingDSL

    @@before_hooks = [] of Http::Request, Http::Response ->
    @@after_hooks = [] of Http::Request, Http::Response ->
    @@router = Router.new

    def initialize
      @server = HTTP::Server.new(
        "127.0.0.1",
        4000,
        [
          HTTP::LogHandler.new,
          HTTP::ErrorHandler.new,
          Http::MainHandler.new(self.class)
        ]
      )
    end

    def run
      puts "Server running ..."
      @server.listen
    end

    def self.routes
      @@router.routes
    end

    def self.wrap_within_self_callables(callables)
      before_hooks + callables + after_hooks
    end

    def self.mount_route(method : String, path : String, callables)
      all_callables = wrap_within_self_callables(callables)
      @@router.add(method, path, all_callables)
    end

    def self.find(request)
      @@router.find(request)
    end
  end
end
