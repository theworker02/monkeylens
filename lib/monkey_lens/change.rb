# frozen_string_literal: true

module MonkeyLens
  class Change
    LEVELS = {"low" => 1, "medium" => 2, "high" => 3, "critical" => 4}.freeze

    attr_reader :type, :severity, :target, :method_id, :before, :after, :message

    def initialize(type:, severity:, target:, method_id: nil, before: nil, after: nil, message:)
      @type = type
      @severity = severity
      @target = target
      @method_id = method_id
      @before = before
      @after = after
      @message = message
    end

    def level
      LEVELS.fetch(severity)
    end

    def to_h
      {
        "type" => type,
        "severity" => severity,
        "target" => target,
        "method" => method_id,
        "message" => message,
        "before" => before,
        "after" => after
      }
    end
  end
end
