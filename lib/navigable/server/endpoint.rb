# frozen_string_literal: true

module Navigable
  module Server
    module Endpoint
      EXECUTE_NOT_IMPLEMENTED_MESSAGE = 'Endpoint classes must either call `executes` or implement an `execute` method.'

      def self.extended(base)
        base.instance_eval do
          def responds_to(verb, path)
            Navigable::Server.add_endpoint(verb: verb, path: path, endpoint_class: self)
          end

          def executes(command_key)
            @command_key = command_key
          end
        end

        base.class_eval do
          attr_reader :request

          def inject(request: Request.new)
            @request = request
          end

          def execute
            raise NotImplementedError.new(EXECUTE_NOT_IMPLEMENTED_MESSAGE) unless command_key

            dispatch
          end

          private

          def dispatch
            Navigable::Dispatcher.dispatch(command_key, params: params, resolver: resolver)
          end

          def command_key
            self.class.instance_variable_get(:@command_key)
          end

          def params
            request.params
          end

          def preferred_media_type
            request.headers[:preferred_media_type]
          end

          def resolver
            Manufacturable.build_one(Resolver::TYPE, preferred_media_type) || Navigable::NullResolver.new
          end
        end
      end
    end
  end
end
