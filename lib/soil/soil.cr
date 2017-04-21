require "http/server"
require "json"

require "./http/*"
require "./routing/*"
require "./application/*"
require "./action/*"
require "./*"

alias Handler = Soil::Action | (Soil::Http::Request, Soil::Http::Response ->)
