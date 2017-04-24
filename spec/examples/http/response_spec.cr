require "../../spec_helper"

module SoilSpec::Http::Response
  class Obj
    def to_json(json : JSON::Builder)
      Mocr::Spy.call
      json.string("")
    end
  end

  describe Soil::Http::Response do
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
  end
end
