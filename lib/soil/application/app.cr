require "./hooks_dsl"
require "./config_dsl"

module Soil
  class App
    extend HooksDSL
    extend RoutingDSL
    extend ConfigDSL

    @@namespace = ""
    @@before_hooks = [] of Http::Request, Http::Response ->
    @@after_hooks = [] of Http::Request, Http::Response ->
    @@router = Router.new
    @@config = Config.new
    @@logger = Logger.new(STDOUT)

    def initialize
      @server = HTTP::Server.new(
        @@config.host,
        @@config.port,
        [
          HTTP::LogHandler.new,
          HTTP::ErrorHandler.new,
          Http::MainHandler.new(self.class)
        ]
      )
    end

    def self.routes
      @@router.routes
    end

    def self.wrap_within_self_callables(callables)
      before_hooks + callables + after_hooks
    end

    def self.mount_route(method : String, path : String, callables)
      path = [@@namespace, path].join("/")
      all_callables = wrap_within_self_callables(callables)
      @@router.add(method, path, all_callables)
    end

    def self.find(request)
      @@router.find(request)
    end

    def self.namespace(name)
      @@namespace = name
    end

    def self.configuration
      @@config
    end

    def self.logger
      @@logger
    end

    def run
      self.class.logger.info(
        "An app emerged from soil running on #{self.class.configuration.host}:#{@server.port}"
      )
      @server.listen
    end
  end
end
