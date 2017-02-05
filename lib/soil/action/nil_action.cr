module Soil
  class NilAction < Action
    def call(request, response)
      response.status_code = 404
    end
  end
end
