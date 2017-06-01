module Soil
  module Action
    include Templating::Macros

    abstract def call(request, response)
  end
end
