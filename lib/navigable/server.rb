require 'hanami/router'
require 'json'
require 'navigable'
require 'rack'
require 'rack/accept_media_types'
require 'rack/abstract_format'
require 'rack/bodyparser'

require 'navigable/server'
require 'navigable/server/version'
require 'navigable/server/request'
require 'navigable/server/response'
require 'navigable/server/rack_adapter'
require 'navigable/server/routes'
require 'navigable/server/router'
require 'navigable/server/endpoint'

module Navigable
  module Server
    def self.rack_app
      @server ||= Rack::Builder.new(Server.router) do
        use Rack::BodyParser, :parsers => { 'application/json' => proc { |data| JSON.parse(data) } }
        use Rack::AbstractFormat
      end
    end

    def self.add_endpoint(**kwargs)
      router.add_endpoint(**kwargs)
    end

    def self.router
      @router ||= Router.new
    end
  end
end