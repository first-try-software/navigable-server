# frozen_string_literal: true

module Navigable
  module Server
    class Router
      def call(env)
        router.call(env)
      end

      def add_endpoint(verb:, path:, endpoint_class:)
        request_adapter = RackAdapter.new(endpoint_class: endpoint_class)
        router.public_send(verb, path, to: request_adapter)
      end

      private

      def router
        @router ||= Navigable::Router.new
      end
    end
  end
end
