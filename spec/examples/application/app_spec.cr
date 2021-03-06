require "../../spec_helper"

include Soil

private class ChildApp < App; end
private class ExampleApp < App; end
private class TemplateApp < App
  get "" do |_, res|
    render_template res, "spec/support/files/template.html.ecr"
  end
end
private class ExampleAction
  include Action

  def call(request, response)
  end
end

describe App do
  context "#configuration" do
    describe "#configure" do
      it "modifies configuration values" do
        ExampleApp.configure do |config|
          config.port = 3000
        end
        ExampleApp.configuration.port.should eq 3000
      end
    end
  end

  context "#hooks" do
    describe "#before" do
      it "registers before hooks" do
        ExampleApp.before {}
        ExampleApp.before_hooks.size.should eq 1
      end
    end

    describe "#after" do
      it "registers after hooks" do
        ExampleApp.after {}
        ExampleApp.after_hooks.size.should eq 1
      end
    end
  end

  context "routing" do
    describe "#get" do
      it "mounts route with an Action handler" do
        number_of_routes = ExampleApp.routes.size
        ExampleApp.get("/", ExampleAction.new)
        ExampleApp.routes.size.should eq number_of_routes + 1
      end

      it "mounts route with a block handler" do
        number_of_routes = ExampleApp.routes.size
        ExampleApp.get("/") {}
        ExampleApp.routes.size.should eq number_of_routes + 1
      end

      it "mounts route with an array of handlers" do
        number_of_routes = ExampleApp.routes.size
        ExampleApp.get("/", [
          ExampleAction.new,
          -> (req : Http::Request, res : Http::Response) {}
        ])
        ExampleApp.routes.size.should eq number_of_routes + 1
      end
    end

    describe "#post" do
      it "mounts route with an Action handler" do
        number_of_routes = ExampleApp.routes.size
        ExampleApp.post("/", ExampleAction.new)
        ExampleApp.routes.size.should eq number_of_routes + 1
      end

      it "mounts route with a block handler" do
        number_of_routes = ExampleApp.routes.size
        ExampleApp.post("/") {}
        ExampleApp.routes.size.should eq number_of_routes + 1
      end

      it "mounts route with an array of handlers" do
        number_of_routes = ExampleApp.routes.size
        ExampleApp.post("/", [
          ExampleAction.new,
          -> (req : Http::Request, res : Http::Response) {}
        ])
        ExampleApp.routes.size.should eq number_of_routes + 1
      end
    end
  end

  describe "#mount" do
    it "mounts child application routes under given paths" do
      number_of_routes = ExampleApp.routes.size
      ChildApp.get("/", ExampleAction.new)
      number_of_child_routes = ChildApp.routes.size

      ExampleApp.mount("/", ChildApp)
      ExampleApp.routes.size.should eq number_of_routes + number_of_child_routes
    end

    it "mounts child application routes under the root path" do
      number_of_routes = ExampleApp.routes.size
      ChildApp.get("/", ExampleAction.new)
      number_of_child_routes = ChildApp.routes.size

      ExampleApp.mount(ChildApp)
      ExampleApp.routes.size.should eq number_of_routes + number_of_child_routes
    end
  end

  context "#templating" do
    it "has template rendering capabilities" do
      request = build_request(Method::GET, "")
      io = IO::Memory.new
      response = build_response(io)
      TemplateApp.routes.first.call(request, response)
      response.close
      io.to_s.should contain "Hello, Soil!"
    end
  end
end
