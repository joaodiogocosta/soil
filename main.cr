require "./lib/soil"

# router = Router.new
# router.add("get", "/api/v2")
# context = "context"
# router.find("get", "/api/v1").call(context)
# router.find("get", "/api/v2").call(context)

class Users < App
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

class V1 < App
  before do
    p "before V1"
  end

  after do
    p "after V1"
  end

  mount "users", Users
end

class V2 < App
  mount "users", Users
end

class Api < App
  mount "v1", V1
  mount "v2", V2
end

# Api.find(:get, 'not_found').call
# Api.find(:get, '').call
Api.find("post", "/v1/users").call("context")
# Api.find(:get, '/v2/users/').call
