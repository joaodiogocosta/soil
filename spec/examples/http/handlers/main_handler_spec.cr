require "../../../spec_helper"

private class ExampleApp < Soil::App
  get "hey" do
    Mocr::Spy.call
  end
end

describe Soil::Http::Handlers::MainHandler do
  it "finds and calls a given route" do
    main_handler = Soil::Http::Handlers::MainHandler.new(ExampleApp)
    main_handler.call(build_raw_context("get", "hey"))
    Mocr::Spy.calls.should eq 1
  end
end
