# frozen_string_literal: true

require_relative "monkey_lens/version"
require_relative "monkey_lens/config"
require_relative "monkey_lens/snapshot"
require_relative "monkey_lens/change"
require_relative "monkey_lens/capture"
require_relative "monkey_lens/diff"
require_relative "monkey_lens/formatter"

module MonkeyLens
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class SnapshotError < Error; end

  module_function

  def capture(targets:, ignore_methods: [])
    Capture.new(targets:, ignore_methods:).call
  end

  def diff(baseline, current)
    Diff.new(baseline:, current:).call
  end

  def evaluate(result, policy:, threshold: "high", today: Date.today)
    policy.evaluate(result, threshold:, today:)
  end
end

require_relative "monkey_lens/policy"
require_relative "monkey_lens/railtie" if defined?(Rails::Railtie)
