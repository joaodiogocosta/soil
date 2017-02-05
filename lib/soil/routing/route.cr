class Route
  getter method
  getter path
  getter callables

  def initialize(method : String, path : String, callables = [] of String ->)
    @method = method
    @path = path
    @callables = callables
  end

  def matches?(method, path)
    (method == @method) && (path == @path)
  end

  def call(context : String)
    @callables.each do |callable|
      callable.call(context)
    end
  end
end

