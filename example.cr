require "./src/soil"

class PostsIndexAction
  include Soil::Action

  def call(req, res)
    p "PostsIndexAction"
  end
end

class Users < Soil::App
  before do |req, res|
    p "before Users"
  end

  after do |req, res|
    p "after Users"
  end

  get "" do |req, res|
    p "awesome get endpoint"
  end

  post "" do |req, res|
    p "awesome post endpoint"
  end

  get ":id" do |req, res|
    p "Fetching user id"
  end
end

class Posts < Soil::App
  get "", [PostsIndexAction.new, -> (req : Soil::Http::Request, res : Soil::Http::Response) {
    # ...
  }]
end

class V1 < Soil::App
  before do |req, res|
    p "before V1"
  end

  after do |req, res|
    p "after V1"
  end

  mount "users", Users
end

class V2 < Soil::App
  mount "users", Users
  mount "posts", Posts
end

class Api < Soil::App
  namespace "public"

  mount "v1", V1
  mount "v2", V2
end

class App < Soil::App
  mount "api", Api
end

App.new.run
