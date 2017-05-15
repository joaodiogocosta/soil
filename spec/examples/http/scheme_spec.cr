require "../../spec"

include Soil

describe Http::Scheme do
  it "has scheme http when scheme is http" do
    req = build_request(Http::Method::GET, "http://example.org")
    Http::Scheme.parse(req).should eq Scheme::HTTP
  end

  describe "when https" do
    it "with header 'HTTPS'" do
      req = build_request(Http::Method::GET, "http://example.org")
      req.headers["HTTPS"] = "on"
      Http::Scheme.parse(req).should eq Scheme::HTTPS
    end

    it "with header 'HTTP_X_FORWARDED_SSL'" do
      req = build_request(Http::Method::GET, "http://example.org")
      req.headers["HTTP_X_FORWARDED_SSL"] = "on"
      Http::Scheme.parse(req).should eq Scheme::HTTPS
    end

    it "with header 'HTTP_X_FORWARDED_SCHEME'" do
      req = build_request(Http::Method::GET, "http://example.org")
      req.headers["HTTP_X_FORWARDED_SCHEME"] = Scheme::HTTPS
      Http::Scheme.parse(req).should eq Scheme::HTTPS
    end

    it "with header 'HTTP_X_FORWARDED_PROTO'" do
      req = build_request(Http::Method::GET, "http://example.org")
      req.headers["HTTP_X_FORWARDED_PROTO"] = Scheme::HTTPS
      Http::Scheme.parse(req).should eq Scheme::HTTPS
    end
  end
end
