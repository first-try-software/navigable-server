# frozen_string_literal: true

module Navigable
  module Server
    module EndpointCommand
      def self.extended(base)
        base.extend(Navigable::Command)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def responds_to(verb, path)
          @responds_to_proc ||= Proc.new do |endpoint_klass|
            endpoint_klass.responds_to(verb, path)
          end

          setup_endpoint_command if ready_for_setup?
        end

        def corresponds_to(command_key)
          @corresponds_to_proc ||= Proc.new do |endpoint_klass, command_klass|
            endpoint_klass.executes(command_key)
            super(command_key)
          end

          setup_endpoint_command if ready_for_setup?
        end

        def setup_endpoint_command
          endpoint_klass = Class.new { extend Navigable::Server::Endpoint }
          @responds_to_proc.call(endpoint_klass)
          @corresponds_to_proc.call(endpoint_klass, self)
        end

        def ready_for_setup?
          @responds_to_proc && @corresponds_to_proc
        end
      end
    end
  end
end
