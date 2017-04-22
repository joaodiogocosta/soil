require "spec"
require "../src/soil"
require "../src/soil/spec"

include Soil::Spec
include Soil::Spec::RouteHelpers

Spec.before_each do
  Mocr::Spy.reset
end
