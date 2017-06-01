require "../../spec_helper"

private class TemplateAction
  include Soil::Action

  def call(req, res)
    render_template res, "spec/support/files/template.html.ecr"
  end
end

describe Soil::Action do
  it "has template rendering capabilities" do
    request = build_request(Method::GET, "")
    io = IO::Memory.new
    response = build_response(io)
    TemplateAction.new.call(request, response)
    response.close
    io.to_s.should contain "Hello, Soil!"
  end
end
