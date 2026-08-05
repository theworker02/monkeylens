# frozen_string_literal: true

require "test_helper"
require "date"
require "tempfile"

class PolicyTest < Minitest::Test
  def test_waives_matching_change_and_keeps_unapproved_change
    approved = MonkeyLens::Change.new(
      type: "method_added", severity: "low", target: "String", method_id: "String#legacy_patch",
      message: "method was added"
    )
    dangerous = MonkeyLens::Change.new(
      type: "owner_changed", severity: "critical", target: "String", method_id: "String#upcase",
      message: "effective method owner changed"
    )
    result = MonkeyLens::Diff::Result.new(baseline: nil, current: nil, changes: [approved, dangerous])
    policy = MonkeyLens::Policy.new(waivers: [
      {type: "method_added", target: "String", method: "String#legacy_*", reason: "legacy compatibility shim"}
    ])

    decision = MonkeyLens.evaluate(result, policy:, threshold: "high", today: Date.new(2026, 8, 4))

    assert_equal [dangerous], decision.effective_changes
    assert_equal 1, decision.waived_changes.length
    assert decision.failure?
    refute decision.clean?
  end

  def test_expired_waiver_does_not_match
    change = MonkeyLens::Change.new(
      type: "source_changed", severity: "high", target: "Array", method_id: "Array#map",
      message: "method implementation source changed"
    )
    result = MonkeyLens::Diff::Result.new(baseline: nil, current: nil, changes: [change])
    policy = MonkeyLens::Policy.new(waivers: [
      {type: "source_changed", target: "Array", method: "Array#map", reason: "temporary", expires_on: "2026-08-01"}
    ])

    decision = policy.evaluate(result, threshold: "high", today: Date.new(2026, 8, 4))
    assert_equal [change], decision.effective_changes
    assert_empty decision.waived_changes
  end

  def test_loads_yaml_policy
    Tempfile.create(["monkeylens", ".yml"]) do |file|
      file.write <<~YAML
        waivers:
          - type: method_added
            target: MyApp::*
            method: "*#instrumented_*"
            reason: instrumentation methods are approved
      YAML
      file.flush
      policy = MonkeyLens::Policy.load(file.path)
      assert_equal 1, policy.waivers.length
      assert_equal "instrumentation methods are approved", policy.waivers.first.reason
    end
  end

  def test_requires_waiver_reason
    assert_raises(MonkeyLens::ConfigurationError) do
      MonkeyLens::Policy.new(waivers: [{type: "method_added", reason: ""}])
    end
  end
end
