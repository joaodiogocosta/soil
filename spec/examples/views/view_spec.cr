require "../../spec_helper"

module Spec::Views::View
  class ExampleView
    include Soil::View
    getter name : String

    def initialize(data)
      @name = data[:name]
    end

    template "spec/examples/views/example.html.ecr"
  end

  describe Soil::Views::View do
    describe "#template" do
      it "compiles a template file" do
        data = { name: "Soil" }
        result = ExampleView.new(data).to_s
        result.should eq "Hello, Soil!"
      end
    end
  end
end
