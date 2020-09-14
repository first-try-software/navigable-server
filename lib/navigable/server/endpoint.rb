module Navigable
  module Server
    class Endpoint
      EXECUTE_NOT_IMPLEMENTED_MESSAGE = 'Class must implement `execute` method.'.freeze

      def self.responds_to(verb, path)
        Navigable::Server.add_endpoint(verb: verb, path: path, endpoint_class: self)
      end

      attr_reader :request

      def initialize(request: Request.new)
        @request = request
      end

      def execute
        raise NotImplementedError.new(EXECUTE_NOT_IMPLEMENTED_MESSAGE)
      end
    end
  end
end