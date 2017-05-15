require "../../../spec_helper"

private class ExampleApp < Soil::App
  get "hey" do |req, res|
    Mocr::Spy.call
    res.halt!
  end
end

private class HaltedApp < Soil::App
  get "halt" do |req, res|
    res.halt!
  end
end

private class NextHandler
  include HTTP::Handler

  def call(context)
    Mocr::Spy.call
  end
end

include Soil::Http

describe Soil::Http::Handlers::MainHandler do
  it "finds and calls a given route" do
    main_handler = Handlers::MainHandler.new(ExampleApp)
    context = build_raw_context do |context|
      context.request.method = Method::GET
      context.request.path = "/hey"
    end
    main_handler.call(context)
    Mocr::Spy.calls.should eq 1
  end

  it "calls next if response is not halted" do
    main_handler = Handlers::MainHandler.new(ExampleApp)
    main_handler.next = NextHandler.new
    context = build_raw_context do |context|
      context.request.method = Method::GET
      context.request.path = "/hey"
    end
    main_handler.call(context)
    Mocr::Spy.calls.should eq 1
  end

  it "does not call next if response is halted" do
    main_handler = Handlers::MainHandler.new(HaltedApp)
    main_handler.next = NextHandler.new
    context = build_raw_context do |context|
      context.request.method = Method::GET
      context.request.path = "/halt"
    end
    main_handler.call(context)
    Mocr::Spy.calls.should eq 0
  end
end
