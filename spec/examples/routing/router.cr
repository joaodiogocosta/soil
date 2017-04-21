require "../../spec_helper"

module SoilSpec::Routing::Router
  extend self

  def build_request(method, path)
    raw_request = HTTP::Request.new(method: method, resource: path)
    request = Soil::Http::Request.new(raw_request)
  end

  describe Soil::Router do
    describe "#add" do
      it "adds routes to the collection" do
        router = Soil::Router.new
        router.add "GET", "", [] of Soil::Action
        router.add "POST", "", [] of Soil::Action
        router.routes.size.should eq 2
      end
    end

    describe "#find" do
      it "finds existing route" do
        router = Soil::Router.new
        router.add "GET", "users", [] of Soil::Action
        request = build_request("GET", "/users")
        router.find(request).should be_a Soil::Route
      end

      it "also returns a route if the route does not match" do
        router = Soil::Router.new
        router.add "GET", "users", [] of Soil::Action
        request = build_request("GET", "/posts")
        router.find(request).should be_a Soil::Route
      end
    end
  end
end
