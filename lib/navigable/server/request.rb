# frozen_string_literal: true

module Navigable
  module Server
    class Request
      PARSED_BODY = 'parsed_body'
      ROUTER_PARAMS = 'router.params'

      attr_reader :env

      def initialize(env = nil)
        @env = env
      end

      def headers
        @headers ||= env ? {
          accept_media_types: accept_media_types,
          preferred_media_type: preferred_media_type
        } : {}
      end

      def params
        @params ||= env ? form_params.merge!(body_params).merge!(url_params) : {}
      end

      private

      def accept_media_types
        @accept_media_types ||= rack_request.accept_media_types
      end

      def preferred_media_type
        accept_media_types.first
      end

      def form_params
        symbolize_keys(rack_request.params || {})
      end

      def body_params
        symbolize_keys(env[PARSED_BODY] || {})
      end

      def url_params
        env[ROUTER_PARAMS] || {}
      end

      def symbolize_keys(hash)
        hash.each_with_object({}) { |(key, value), obj| obj[key.to_sym] = value }
      end

      def rack_request
        @rack_request ||= Rack::Request.new(env)
      end
    end
  end
end