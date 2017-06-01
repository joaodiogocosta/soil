require "../../spec_helper"

private class DataView
  include Soil::View

  getter name : String

  def initialize(data)
    @name = data[:name]
  end

  def render(io : IO)
    render_template io,
      "spec/examples/views/template.html.ecr"
  end
end

describe Soil::Views::View do
  describe "#render" do
    it "compiles a template file with data" do
      data = { name: "Soil" }
      result = DataView.new(data).render
      result.should eq "Hello, Soil!"
    end
  end
end
