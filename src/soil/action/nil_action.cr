module Soil
  class NilAction
    include Action

    def call(request, response)
      response.status_code = Http::Statuses::NotFound.code
    end
  end
end
