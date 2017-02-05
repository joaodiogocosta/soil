require "./lib/soil"

class PostsIndexAction < Soil::Action
  def call(context)
    p "PostsIndexAction"
  end
end

class Users < Soil::App
  before do
    p "before Users"
  end

  after do
    p "after Users"
  end

  get "" do
    p "beautiful get endpoint"
  end

  post "" do
    p "beautiful post endpoint"
  end

  get "" do
    "empty"
  end
end

class Posts < Soil::App
  get "", PostsIndexAction.new
end

class V1 < Soil::App
  before do
    p "before V1"
  end

  after do
    p "after V1"
  end

  mount "users", Users
end

class V2 < Soil::App
  mount "users", Users
  mount "posts", Posts
end

class Api < Soil::App
  mount "v1", V1
  mount "v2", V2
end

# Api.find(:get, 'not_found').call
# Api.find(:get, '').call
Api.find("post", "/v1/users").call("context")
Api.find("get", "/v2/posts").call("context")
# Api.find(:get, '/v2/users/').call
