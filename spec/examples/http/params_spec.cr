require "../../spec_helper"

describe Soil::Http::Params do
  describe ".parse" do
    it "captures query parameters" do
      raw_req = build_raw_request("get", "/?search=term")
      params = Soil::Http::Params.parse(raw_req)
      params.query["search"].should eq "term"
    end

    context "captures text body" do
      it "when empty" do
        raw_req = build_raw_request("get", "/")
        params = Soil::Http::Params.parse(raw_req)
        params.body.text.should eq nil
      end

      it "when text" do
        raw_req = build_raw_request("get", "/")
        raw_req.body = "Hey!"
        params = Soil::Http::Params.parse(raw_req)
        params.body.text.should eq "Hey!"
      end
    end

    context "captures JSON body parameters" do
      it "when hash" do
        raw_req = build_raw_request("get", "/")
        raw_req.body = "{ \"foo\": { \"foo\": \"bar\" }}"
        params = Soil::Http::Params.parse(raw_req)
        params.body.json["foo"]["foo"].should eq "bar"
      end

      it "when array" do
        raw_req = build_raw_request("get", "/")
        raw_req.body = "[1]"
        params = Soil::Http::Params.parse(raw_req)
        params.body.json.as_a[0].should eq 1
      end

      it "when empty" do
        raw_req = build_raw_request("get", "/")
        params = Soil::Http::Params.parse(raw_req)
        params.body.json.should eq nil
      end

      it "when invalid json" do
        raw_req = build_raw_request("get", "/")
        raw_req.body = "Hello there!"
        params = Soil::Http::Params.parse(raw_req)
        params.body.json.should eq nil
      end
    end
  end
end
