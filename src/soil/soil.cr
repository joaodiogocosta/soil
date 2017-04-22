require "http/server"
require "logger"
require "json"

require "./config"
require "./http/*"
require "./routing/*"
require "./application/*"
require "./action/*"
require "./*"

module Soil
  alias Handler = Soil::Action | (Soil::Http::Request, Soil::Http::Response ->)
end

