require "./hooks_dsl"

class App
  extend HooksDSL
  extend RoutingDSL

  @@before_callbacks = [] of String ->
  @@after_callbacks = [] of String ->
  @@router = Router.new

  def self.routes
    @@router.routes
  end

  def self.wrap_within_self_callables(callables)
    callables ||= [] of String ->
    before_callbacks + callables + after_callbacks
  end

  def self.mount_route(method : String, path : String, callables = [] of String ->)
    all_callables = wrap_within_self_callables(callables)
    @@router.add(method, path, all_callables)
  end

  def self.find(method, path)
    @@router.find(method, path)
  end
end

