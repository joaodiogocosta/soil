class Route
  attr_reader :method, :path, :callables

  def initialize(method, path, callables)
    @method = method
    @path = path
    @callables = callables
  end

  def call(context = nil)
    callables.each { |callable| callable.call(context) }
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add(method, path, callables = [])
    @routes << Route.new(method, path, callables)
  end

  def find(method, path)
    found = @routes.detect do |route|
      (route.method == method) && (route.path == path)
    end
    found || Proc.new { p 'not found' }
  end
end

class App
  def self.before_callbacks
    @before_callbacks ||= []
  end

  def self.before(&block)
    before_callbacks << block
  end

  def self.after_callbacks
    @after_callbacks ||= []
  end

  def self.after(&block)
    after_callbacks << block
  end

  def self.router
    @router ||= Router.new
  end

  def self.routes
    @router.routes
  end

  def self.wrap_within_self_callables(callables)
    before_callbacks + (callables || []) + after_callbacks
  end

  def self.mount(path = '/', klass)
    klass.routes.each do |route|
      path = "/#{path}" unless path.start_with?('/')
      callables = wrap_within_self_callables(route.callables)
      router.add(route.method, path + route.path, callables)
    end
  end

  def self.get(path = '/', &block)
    path = "/#{path}" unless path.start_with?('/')
    callables = wrap_within_self_callables([block])
    router.add(:get, path, callables)
  end

  def self.find(method, path)
    router.find(method, path)
  end
end

class Users < App
  before do
    p 'before Users'
  end

  after do
    p 'after Users'
  end

  get '' do
    p 'beautiful endpoint'
  end

  get '' do
    'empty'
  end
end

class V1 < App
  before do
    p 'before V1'
  end

  after do
    p 'after V1'
  end

  mount 'users', Users
end

class V2 < App
  mount 'users', Users
end

class Api < App
  mount 'v1', V1
  mount 'v2', V2
end

# Api.find(:get, 'not_found').call
# Api.find(:get, '').call
Api.find(:get, '/v1/users/').call
# Api.find(:get, '/v2/users/').call
