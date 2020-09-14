module Navigable
  module Server
    class Request
      def initialize(env = nil)
        @env = env
      end

      def headers
        @headers ||= @env ? Headers.new(@env).to_h : {}
      end

      def params
        @params ||= @env ? Params.new(@env).to_h : {}
      end

      private

      class Headers
        attr_reader :env

        def initialize(env)
          @env = env
        end

        def to_h
          {
            accept_media_types: accept_media_types,
            preferred_media_type: preferred_media_type
          }
        end

        private

        def accept_media_types
          @accept_media_types ||= Rack::Request.new(env).accept_media_types
        end

        def preferred_media_type
          accept_media_types.first
        end
      end
    end

    class Params
      attr_reader :env

      def initialize(env)
        @env = env
      end

      def to_h
        [form_params, body_params, url_params].reduce(&:merge)
      end

      private

      def form_params
        @form_params ||= symbolize_keys(Rack::Request.new(env).params || {})
      end

      def body_params
        @body_params ||= symbolize_keys(env['parsed_body'] || {})
      end

      def url_params
        @url_params ||= env['router.params'] || {}
      end

      def symbolize_keys(hash)
        hash.each_with_object({}) { |(key, value), obj| obj[key.to_sym] = value }
      end
    end
  end
end