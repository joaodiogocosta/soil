module Soil
  class NilAction
    include Action

    def call(request, response)
      response.status_code = Http::Status::NotFound.code
    end
  end
end
