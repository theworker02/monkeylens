# frozen_string_literal: true

require "date"
require "yaml"

module MonkeyLens
  class Policy
    class Waiver
      attr_reader :type, :target, :method_pattern, :reason, :expires_on

      def initialize(type: "*", target: "*", method: "*", reason:, expires_on: nil)
        raise ConfigurationError, "waiver reason is required" if reason.to_s.strip.empty?

        @type = type.to_s
        @target = target.to_s
        @method_pattern = method.to_s
        @reason = reason.to_s
        @expires_on = expires_on && Date.iso8601(expires_on.to_s)
      rescue Date::Error
        raise ConfigurationError, "invalid waiver expiration #{expires_on.inspect}"
      end

      def match?(change, today: Date.today)
        return false if expired?(today:)

        matches?(type, change.type) &&
          matches?(target, change.target) &&
          matches?(method_pattern, change.method_id.to_s)
      end

      def expired?(today: Date.today)
        expires_on && expires_on < today
      end

      def to_h
        {
          "type" => type,
          "target" => target,
          "method" => method_pattern,
          "reason" => reason,
          "expires_on" => expires_on&.iso8601
        }.compact
      end

      private

      def matches?(pattern, value)
        File.fnmatch?(pattern, value.to_s, File::FNM_EXTGLOB)
      end
    end

    class Decision
      attr_reader :result, :effective_changes, :waived_changes, :threshold

      def initialize(result:, effective_changes:, waived_changes:, threshold:)
        @result = result
        @effective_changes = effective_changes.freeze
        @waived_changes = waived_changes.freeze
        @threshold = threshold.to_s
      end

      def clean?
        effective_changes.empty?
      end

      def failure?
        minimum = Change::LEVELS.fetch(threshold)
        effective_changes.any? { |change| change.level >= minimum }
      end

      def to_h
        {
          "schema" => 1,
          "clean" => clean?,
          "failure" => failure?,
          "threshold" => threshold,
          "summary" => Change::LEVELS.keys.to_h do |level|
            [level, effective_changes.count { |change| change.severity == level }]
          end,
          "effective_changes" => effective_changes.map(&:to_h),
          "waived_changes" => waived_changes.map do |item|
            {"change" => item.fetch(:change).to_h, "waiver" => item.fetch(:waiver).to_h}
          end
        }
      end
    end

    attr_reader :waivers

    def self.load(path)
      data = YAML.safe_load_file(path, permitted_classes: [Date], aliases: false) || {}
      from_hash(data)
    rescue Psych::Exception => error
      raise ConfigurationError, "invalid policy file #{path}: #{error.message}"
    end

    def self.from_hash(data)
      values = data["waivers"] || data[:waivers] || []
      new(waivers: values)
    end

    def initialize(waivers: [])
      @waivers = waivers.map do |waiver|
        waiver.is_a?(Waiver) ? waiver : Waiver.new(**symbolize(waiver))
      end.freeze
    end

    def evaluate(result, threshold: "high", today: Date.today)
      Change::LEVELS.fetch(threshold.to_s)
      effective = []
      waived = []
      result.changes.each do |change|
        waiver = waivers.find { |candidate| candidate.match?(change, today:) }
        waiver ? waived << {change:, waiver:} : effective << change
      end
      Decision.new(result:, effective_changes: effective, waived_changes: waived, threshold:)
    end

    private

    def symbolize(value)
      value.to_h.each_with_object({}) { |(key, item), result| result[key.to_sym] = item }
    end
  end
end
