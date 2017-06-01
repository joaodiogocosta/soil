require "http/server"
require "logger"
require "json"

require "./soil/templating/**"
require "./soil/config"
require "./soil/http/**"
require "./soil/routing/**"
require "./soil/application/**"
require "./soil/action/**"
require "./soil/views/**"
require "./soil/*"

module Soil
  alias Handler = Action | (Http::Request, Http::Response ->)
  alias View = Views::View
end

