# frozen_string_literal: true

module Navigable
  module Server
    class Response
      CONTENT_TYPE = 'Content-Type'
      MIME_TYPE_JSON = 'application/json'
      MIME_TYPE_HTML = 'text/html'
      MIME_TYPE_TEXT = 'text/plain'
      EMPTY_CONTENT = ''

      attr_reader :params, :status

      def initialize(params)
        @params = params
        @status = params[:status] || 200
      end

      def to_rack_response
        [status, headers, content]
      end

      private

      def headers
        headers = params[:headers] || {}
        headers[CONTENT_TYPE] = content_type if content_type
        headers
      end

      def content_type
        return MIME_TYPE_JSON if json
        return MIME_TYPE_HTML if html
        return MIME_TYPE_TEXT if text
      end

      def content
        [json || html || text || body || EMPTY_CONTENT]
      end

      def json
        return unless params[:json]
        return stringified_json if valid_json?

        params[:json].to_json
      end

      def html
        params[:html]
      end

      def text
        params[:text]
      end

      def body
        params[:body]
      end

      def valid_json?
        JSON.parse(stringified_json)
        return true
      rescue JSON::ParserError => e
        return false
      end

      def stringified_json
        @stringified_json ||= params[:json].to_s
      end
    end
  end
end