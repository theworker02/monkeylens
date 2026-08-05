# frozen_string_literal: true

require_relative "formatter/text"
require_relative "formatter/json"
require_relative "formatter/sarif"

module MonkeyLens
  module Formatter
    module_function

    def render(result, format: "text")
      formatter = case format.to_s
                  when "text" then Text
                  when "json" then JSON
                  when "sarif" then SARIF
                  else raise ConfigurationError, "unknown format #{format}"
                  end
      formatter.new(result).render
    end
  end
end
