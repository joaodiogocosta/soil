require "../../spec_helper"

module SoilSpec::MainHandler
  class ExampleApp < Soil::App
    get "hey" do
      Mocr::Spy.call
    end
  end

  describe Soil::Http::MainHandler do
    it "finds and calls a given route" do
      main_handler = Soil::Http::MainHandler.new(ExampleApp)
      main_handler.call(build_raw_context("get", "hey"))
      Mocr::Spy.calls.should eq 1
    end
  end
end
