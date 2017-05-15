require "../../spec_helper"

private class Obj
  def to_json(io : IO)
    { "JSON" => "rules the web" }.to_json(io)
  end
end

private class ExampleView
  include Soil::View

  getter name : String

  def initialize(data)
    @name = data[:name]
  end

  def render(io : IO)
    render_template io, "spec/examples/http/example.html.ecr"
  end
end

include Soil::Http

describe Soil::Http::Response do
  it "is not halted by default" do
    res = build_response
    res.halted?.should eq false
  end

  describe "#html" do
    it "sets the content type to text/html" do
      res = build_response
      res.html("<html></html>")
      res.headers["Content-Type"].should eq "text/html"
    end
  end

  describe "#json" do
    it "sets the content type to application/json" do
      res = build_response
      res.json({ "foo" => "bar" })
      res.headers["Content-Type"].should eq "application/json"
    end

    it "writes the given JSON to the response" do
      io = IO::Memory.new
      res = build_response(io)
      object = Obj.new
      res.json(object)
      res.close
      io.to_s.should contain "{\"JSON\":\"rules the web\"}"
    end
  end

  describe "#render" do
    it "sets the content type to text/html" do
      res = build_response
      data = { name: "Soil" }
      res.render(ExampleView, data)
      res.headers["Content-Type"].should eq "text/html"
    end

    it "writes the compiled template to the response" do
      io = IO::Memory.new
      res = build_response(io)
      data = { name: "Soil" }
      res.render(ExampleView, data).to_s
      res.close
      io.to_s.should contain "Hello, Soil!"
    end
  end

  describe "#text" do
    it "sets the content type to text/plain" do
      res = build_response
      res.text("Soil says hi!")
      res.headers["Content-Type"].should eq "text/plain"
    end

    it "writes the given text to the response" do
      io = IO::Memory.new
      res = build_response(io)
      res.text("Soil says hi!")
      res.close
      io.to_s.should contain "Soil says hi!"
    end
  end

  describe "#halt!" do
    it "halts the response" do
      res = build_response
      res.halt!
      res.halted?.should eq true
    end
  end

  describe "#redirect" do
    it "halts the response" do
      res = build_response
      res.redirect("/")
      res.halted?.should eq true
    end

    it "sets the status code to 302 if method is GET" do
      res = build_response
      res.redirect("/")
      res.status_code.should eq 302
    end

    it "sets the status code to 303 if method is other than GET" do
      res = build_response do |context, _|
        context.request.method = Method::POST
      end
      res.redirect("/")
      res.status_code.should eq 303
    end

    describe "with path" do
      it "sets the header 'Location' to the constructed url" do
        res = build_response do |context, app|
          context.request.path = "/old/path?foo=bar"
          app.configuration.host = "example.org"
          app.configuration.port = 3456
        end
        res.redirect("/new/path")
        res.headers["Location"].should eq "http://example.org:3456/new/path"
      end
    end

    describe "with url" do
      it "simply sets the header to the url passed as argument" do
        res = build_response do |context, app|
          context.request.path = "/old/path?foo=bar"
        end
        res.redirect("http://soil.cr/new/path")
        res.headers["Location"].should eq "http://soil.cr/new/path"
      end
    end
  end
end
