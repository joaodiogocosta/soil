require "../../spec_helper"

private class TemplateView
  include Soil::View

  def render(io : IO)
    render_template io, "spec/examples/views/template.html.ecr"
  end
end

private class DataView
  include Soil::View

  getter name : String

  def initialize(data)
    @name = data[:name]
  end

  def render(io : IO)
    render_template io,
      "spec/examples/views/template_with_data.html.ecr"
  end
end

private class LayoutView
  include Soil::View

  def render(io : IO)
    render_template io,
      "spec/examples/views/template.html.ecr",
      layout: "spec/examples/views/layout.html.ecr"
  end
end

describe Soil::Views::View do
  describe "#render_template" do
    it "compiles a template file" do
      result = TemplateView.new.render
      result.should eq "Hello, Soil!"
    end

    it "compiles a template file with data" do
      data = { name: "Soil" }
      result = DataView.new(data).render
      result.should eq "Hello, Soil!"
    end

    it "compiles a template file with a layout" do
      result = LayoutView.new.render
      result.should eq "<p>Hello, Soil!</p>"
    end
  end
end
