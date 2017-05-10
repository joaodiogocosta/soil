module Soil
  class Config
    # Binding
    property host = "127.0.0.1"
    property port = 4000

    # Static Files
    property serve_static_files = false
    property public_dir = "public"
  end
end
