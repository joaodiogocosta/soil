require "../../spec_helper"

module SoilSpec::Routing::Route
  describe Soil::Route do
    describe "matching" do
      it "matches HTTP method" do
        route = build_route("GET", "")

        req = build_example_request("POST", "")
        route.matches?(req).should eq false

        req = build_example_request("GET", "")
        route.matches?(req).should eq true
      end

      it "matches root (slash only) route" do
        route = build_route("GET", "/")

        req = build_example_request("GET", "/")
        route.matches?(req).should eq true
      end

      it "matches route" do
        route = build_route("GET", "/users")

        req = build_example_request("GET", "/posts")
        route.matches?(req).should eq false

        req = build_example_request("GET", "/users")
        route.matches?(req).should eq true
      end

      it "ignores traling slash" do
        route = build_route("get", "/users")
        req = build_example_request("get", "/users/")
        route.matches?(req).should eq true
      end

      it "ignores URL params identifier (question mark => ?)" do
        route = build_route("get", "/users")
        req = build_example_request("get", "/users?foo=bar")
        route.matches?(req).should eq true
      end

      it "ignores trailing slash combined with URL params identifier" do
        route = build_route("get", "/users")
        req = build_example_request("get", "/users/?foo=bar")
        route.matches?(req).should eq true
      end

      describe "with named parameters" do
        it "matches named parameter as terminal" do
          route = build_route("get", "/users/:id")
          req = build_example_request("get", "/users/12345")
          route.matches?(req).should eq true
        end

        it "matches named parameter in the middle of the path" do
          route = build_route("get", "/users/:id/posts")
          req = build_example_request("get", "/users/12345/posts")
          route.matches?(req).should eq true
        end

        it "matches named parameter with trailing slash" do
          route = build_route("get", "/users/:id/")
          req = build_example_request("get", "/users/12345/")
          route.matches?(req).should eq true
        end

        it "matches multiple named parameter" do
          route = build_route("get", "/users/:user_id/posts/:post_id")
          req = build_example_request("get", "/users/12345/posts/6789")
          route.matches?(req).should eq true
        end

        it "stores parameters" do
          route = build_route("get", "/users/:id/")
          req = build_example_request("get", "/users/12345/")
          route.matches?(req)
          req.params["id"].should eq "12345"
        end

        it "stores multiple parameters" do
          route = build_route("get", "/users/:user_id/posts/:post_id")
          req = build_example_request("get", "/users/12345/posts/6789")
          route.matches?(req)
          req.params["user_id"].should eq "12345"
          req.params["post_id"].should eq "6789"
        end
      end
    end

    describe "#call" do
      it "calls callables" do
        handler1 = build_handler { Mocr::Spy.call }
        handler2 = build_handler { Mocr::Spy.call }
        route = build_route("get", "/", [handler1, handler2])

        request = build_example_request("get", "/")
        response = build_example_response
        route.call(request, response)
        Mocr::Spy.calls.should eq 2
      end
    end
  end
end
