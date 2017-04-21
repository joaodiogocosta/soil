require "spec"
require "../lib/soil"
require "../lib/soil/spec"

include Soil::Spec
include Soil::Spec::RouteHelpers

Spec.before_each do
  Mocr::Spy.reset
end

