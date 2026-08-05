# frozen_string_literal: true

module MonkeyLens
  module Formatter
    class Text
      def initialize(result)
        @result = result
      end

      def render
        return "MonkeyLens PASS — no runtime drift detected" if @result.clean?

        counts = Change::LEVELS.keys.map do |level|
          "#{@result.changes.count { |change| change.severity == level }} #{level}"
        end.join(", ")

        lines = ["MonkeyLens DRIFT — #{counts}", ""]
        @result.changes.each do |change|
          subject = change.method_id || change.target
          lines << "[#{change.severity.upcase}] #{change.type} #{subject}"
          lines << "  #{change.message}"
          lines << "  before: #{change.before.inspect}" unless change.before.nil?
          lines << "  after:  #{change.after.inspect}" unless change.after.nil?
          lines << ""
        end
        lines.join("\n").rstrip
      end
    end
  end
end
