# frozen_string_literal: true

require 'navigable/router'
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
require 'navigable/server/router'
require 'navigable/server/endpoint'
require 'navigable/server/cors'

module Navigable
  module Server
    BODY_PARSERS = {
      'application/json' => proc { |data| JSON.parse(data) }
    }.freeze

    def self.rack_app
      @server ||= Rack::Builder.new(Server.router) do
        use Navigable::Server::CORS::Middleware
        use Rack::BodyParser, :parsers => BODY_PARSERS
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