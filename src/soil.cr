require "http/server"
require "logger"
require "json"

require "./soil/config"
require "./soil/http/*"
require "./soil/routing/*"
require "./soil/application/*"
require "./soil/action/*"
require "./soil/*"

module Soil
  alias Handler = Soil::Action | (Soil::Http::Request, Soil::Http::Response ->)
end

