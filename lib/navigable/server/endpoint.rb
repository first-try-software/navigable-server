# frozen_string_literal: true

module Navigable
  module Server
    module Endpoint
      EXECUTE_NOT_IMPLEMENTED_MESSAGE = 'Class must implement `execute` method.'

      def self.extended(base)
        base.instance_eval do
          def responds_to(verb, path)
            Navigable::Server.add_endpoint(verb: verb, path: path, endpoint_class: self)
          end
        end

        base.class_eval do
          attr_reader :request

          def inject(request: Request.new)
            @request = request
          end

          def execute
            raise NotImplementedError.new(EXECUTE_NOT_IMPLEMENTED_MESSAGE)
          end
        end
      end
    end
  end
end