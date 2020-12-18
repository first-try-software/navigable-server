module Navigable
  module Server
    class CORS
      class << self
        def config
          yield(self)
        end

        def headers
          @headers ||= {}
        end

        def headers=(headers)
          raise ArgumentError.new("Expected headers to be a Hash, received a #{headers.class} instead") unless headers.is_a?(Hash)

          @headers = headers
        end
      end

      class Middleware
        def initialize(app)
          @app = app
        end

        def call(env)
          return @app.call(env) unless cors_configured? && cors_request?(env)

          cors_response
        end

        private

        def cors_configured?
          !Navigable::Server::CORS.headers.empty?
        end

        def cors_request?(env)
          env['REQUEST_METHOD'] == 'OPTIONS'
        end

        def cors_response
          [200, default_headers.merge(Navigable::Server::CORS.headers), []]
        end

        def default_headers
          {
            'Content-Type' => 'text/plain',
            'Content-Length' => '0'
          }
        end
      end
    end
  end
end
