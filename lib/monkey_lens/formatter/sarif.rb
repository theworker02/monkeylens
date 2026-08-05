# frozen_string_literal: true

require "json"

module MonkeyLens
  module Formatter
    class SARIF
      LEVELS = {"low" => "note", "medium" => "warning", "high" => "error", "critical" => "error"}.freeze

      def initialize(result)
        @result = result
      end

      def render
        ::JSON.pretty_generate(
          {
            "$schema" => "https://json.schemastore.org/sarif-2.1.0.json",
            "version" => "2.1.0",
            "runs" => [{
              "tool" => {"driver" => {"name" => "MonkeyLens", "version" => MonkeyLens::VERSION, "rules" => rules}},
              "results" => results
            }]
          }
        )
      end

      private

      def rules
        @result.changes.map(&:type).uniq.sort.map do |type|
          {"id" => type, "shortDescription" => {"text" => type.tr("_", " ")}}
        end
      end

      def results
        @result.changes.map do |change|
          {
            "ruleId" => change.type,
            "level" => LEVELS.fetch(change.severity),
            "message" => {"text" => "#{change.target}#{change.method_id ? " #{change.method_id}" : ""}: #{change.message}"},
            "properties" => change.to_h
          }
        end
      end
    end
  end
end
