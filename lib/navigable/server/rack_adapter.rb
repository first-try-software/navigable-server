module Navigable
  module Server
    class RackAdapter
      attr_reader :endpoint_class

      def initialize(endpoint_class:)
        @endpoint_class = endpoint_class
      end

      def call(env)
        request = Request.new(env)
        endpoint = endpoint_class.new(request: request)
        response = Response.new(endpoint.execute)

        response.to_rack_response
      end
    end
  end
end
