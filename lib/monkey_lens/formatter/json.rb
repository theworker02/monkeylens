# frozen_string_literal: true

require "json"

module MonkeyLens
  module Formatter
    class JSON
      def initialize(result)
        @result = result
      end

      def render
        ::JSON.pretty_generate(@result.to_h)
      end
    end
  end
end
