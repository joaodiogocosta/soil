require "../../spec_helper"

module SoilSpec::Http::Response
  class Obj
    def to_json(json : JSON::Builder)
      Mocr::Spy.call
      json.string("")
    end

    def to_s(io : IO)
      Mocr::Spy.call
      super
    end
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

      it "calls #to_json on the object" do
        object = Obj.new
        res = build_response
        res.json(object)
        Mocr::Spy.calls.should eq 1
      end
    end

    describe "#text" do
      it "sets the content type to text/plain" do
        res = build_response
        res.text("Soil says hi!")
        res.headers["Content-Type"].should eq "text/plain"
      end

      it "calls #to_s on the object" do
        object = Obj.new
        res = build_response
        res.text(object)
        Mocr::Spy.calls.should eq 1
      end
    end
  end
end
