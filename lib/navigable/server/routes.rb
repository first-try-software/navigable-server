module Navigable
  module Server
    class Routes
      def initialize(stdout = STDOUT)
        @routes = []
        @stdout = stdout
      end

      def add(verb, path, endpoint_class)
        @routes << Route.new(verb, path, endpoint_class)
      end

      def print
        @routes.sort_by(&:path).each { |route| @stdout.puts(route.print(max_path_length)) }
      end

      private

      def max_path_length
        @routes.map { |route| route.path.length }.max
      end

      class Route
        attr_reader :verb, :path, :endpoint_class

        def initialize(verb, path, endpoint_class)
          @verb, @path, @endpoint_class = verb, path, endpoint_class
        end

        def print(path_length)
          "#{justified_verb} #{justified_path(path_length)} => #{endpoint_class}"
        end

        def justified_verb
          "#{justify(8, 6, verb.upcase)}"
        end

        def justified_path(path_length)
          "#{justify(-path_length, path_length, path)}"
        end

        def justify(max, trunc, string)
          "%#{max}.#{trunc}s" % string
        end
      end
    end
  end
end
