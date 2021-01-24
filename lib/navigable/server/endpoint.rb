# frozen_string_literal: true

module Navigable
  module Server
    module Endpoint
      EXECUTE_NOT_IMPLEMENTED_MESSAGE = 'Endpoint classes must either call `executes` or implement an `execute` method.'
      UNAUTHENTICATED = { status: 401, text: 'Unauthorized' }.freeze
      UNAUTHORIZED = { status: 403, text: 'Forbidden' }.freeze

      def self.extended(base)
        base.extend(ClassMethods)
        base.include(InstanceMethods)
      end

      module ClassMethods
        def responds_to(verb, path)
          Navigable::Server.add_endpoint(verb: verb, path: path, endpoint_class: self)
        end

        def executes(command_key)
          @command_key = command_key
        end
      end

      module InstanceMethods
        attr_reader :request

        def inject(request: Request.new)
          @request = request
        end

        def execute
          raise NotImplementedError.new(EXECUTE_NOT_IMPLEMENTED_MESSAGE) unless command_key

          auth_response || dispatch
        end

        private

        def auth_response
          return unauthenticated unless authenticated?
          return unauthorized unless authorized?
        end

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

        def unauthenticated
          UNAUTHENTICATED
        end

        def unauthorized
          UNAUTHORIZED
        end

        def authenticated?
          true
        end

        def authorized?
          true
        end
      end
    end
  end
end
