# frozen_string_literal: true

module Navigable
  module Server
    class RackAdapter
      attr_reader :endpoint_class

      def initialize(endpoint_class:)
        @endpoint_class = endpoint_class
      end

      def call(env)
        Response.new(endpoint(request(env)).execute).to_rack_response
      end

      private

      def request(env)
        Request.new(env)
      end

      def endpoint(request)
        endpoint_class.new(request: request)
      end
    end
  end
end
