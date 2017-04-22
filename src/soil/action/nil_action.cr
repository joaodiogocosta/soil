module Soil
  class NilAction < Action
    def call(request, response)
      response.status_code = Http::Statuses::NotFound.code
    end
  end
end
