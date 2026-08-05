# frozen_string_literal: true

require "yaml"

module MonkeyLens
  class Config
    LEVELS = %w[low medium high critical].freeze
    FORMATS = %w[text json sarif].freeze

    attr_reader :targets, :ignore_methods, :fail_on, :format, :baseline, :requires

    def initialize(targets:, ignore_methods: [], fail_on: "high", format: "text", baseline: ".monkeylens.json", requires: [])
      @targets = Array(targets).map(&:to_s).uniq
      @ignore_methods = Array(ignore_methods).map(&:to_s).uniq
      @fail_on = fail_on.to_s
      @format = format.to_s
      @baseline = baseline.to_s
      @requires = Array(requires).map(&:to_s)
      validate!
    end

    def self.load(path = ".monkeylens.yml")
      data = File.exist?(path) ? YAML.safe_load_file(path, permitted_classes: [], aliases: false) : {}
      data ||= {}
      new(
        targets: data.fetch("targets", []),
        ignore_methods: data.fetch("ignore_methods", []),
        fail_on: data.fetch("fail_on", "high"),
        format: data.fetch("format", "text"),
        baseline: data.fetch("baseline", ".monkeylens.json"),
        requires: data.fetch("requires", [])
      )
    rescue Psych::Exception => error
      raise ConfigurationError, "invalid YAML in #{path}: #{error.message}"
    end

    private

    def validate!
      raise ConfigurationError, "targets must contain at least one class or module name" if targets.empty?
      raise ConfigurationError, "fail_on must be one of #{LEVELS.join(", ")}" unless LEVELS.include?(fail_on)
      raise ConfigurationError, "format must be one of #{FORMATS.join(", ")}" unless FORMATS.include?(format)
    end
  end
end
