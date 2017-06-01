require "../../spec_helper"

module TemplatingMacrosSpec
  include Soil::Templating::Macros

  describe Soil::Templating::Macros do
    describe "#render_template" do
      it "compiles a template file" do
        io = IO::Memory.new
        render_template(
          io,
          "spec/examples/templating/template.html.ecr"
        )
        io.to_s.should eq "Hello, Soil!"
      end

      it "compiles a template file with a layout" do
        io = IO::Memory.new
        render_template(
          io,
          "spec/examples/templating/template.html.ecr",
          layout: "spec/examples/templating/layout.html.ecr"
        )
        io.to_s.should eq "<p>Hello, Soil!</p>"
      end

      it "compiles a template file with data" do
        io = IO::Memory.new
        name = "Soil"
        render_template(
          io,
          "spec/examples/templating/template_with_data.html.ecr"
        )
        io.to_s.should eq "Hello, Soil!"
      end
    end
  end
end
