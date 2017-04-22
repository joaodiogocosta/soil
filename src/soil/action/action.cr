module Soil
  abstract class Action
    abstract def call(request, response)
  end
end
