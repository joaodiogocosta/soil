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

  template "spec/examples/http/example.html.ecr"
end

describe Soil::Http::Response do
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
end
