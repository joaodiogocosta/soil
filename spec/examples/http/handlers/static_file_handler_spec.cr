require "../../../spec_helper"

private def handle(request, enabled = false)
  io = IO::Memory.new
  response = HTTP::Server::Response.new(io)
  context = HTTP::Server::Context.new(request, response)
  handler = Soil::Http::Handlers::StaticFileHandler.new(
    "#{__DIR__}/static",
    enabled: enabled
  )
  handler.call context
  response.close
  io.rewind
  HTTP::Client::Response.from_io(io)
end

describe Soil::Http::Handlers::StaticFileHandler do
  it "is disabled by default" do
    response = handle HTTP::Request.new("GET", "/index.html")
    response.status_code.should eq(404)
  end

  it "serves files if enabled" do
    response = handle(HTTP::Request.new("GET", "/index.html"), enabled: true)
    response.status_code.should eq(200)
    response.body.should eq(File.read("#{__DIR__}/static/index.html"))
  end

  it "is always disabled for the root path '/'" do
    response = handle(HTTP::Request.new("GET", "/"), enabled: true)
    response.status_code.should eq(404)
  end
end
