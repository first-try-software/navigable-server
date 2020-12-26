# frozen_string_literal: true

module Navigable
  module Server
    module Parsers
      class Factory
        def self.build(media_type:)
          case media_type
          when /application\/json/
            Parsers::JSON
          else
            Parsers::Null
          end
        end
      end
    end
  end
end
