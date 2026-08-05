# frozen_string_literal: true

require "test_helper"

class MonkeyLensDiffFixture
  def greet(name)
    "hello #{name}"
  end
end

class DiffTest < Minitest::Test
  def test_detects_prepend_and_owner_change
    baseline = MonkeyLens.capture(targets: ["MonkeyLensDiffFixture"])

    patch = Module.new do
      def greet(name)
        "patched #{super}"
      end
    end
    MonkeyLensDiffFixture.prepend(patch)

    current = MonkeyLens.capture(targets: ["MonkeyLensDiffFixture"])
    result = MonkeyLens.diff(baseline, current)

    refute result.clean?
    assert result.changes.any? { |change| change.type == "ancestor_chain_changed" }
    assert result.changes.any? do |change|
      change.type == "owner_changed" && change.method_id == "MonkeyLensDiffFixture#greet"
    end
    assert result.failure?("high")
  end

  def test_clean_snapshots_have_no_changes
    snapshot = MonkeyLens.capture(targets: ["String"])
    result = MonkeyLens.diff(snapshot, snapshot)

    assert result.clean?
    refute result.failure?("critical")
  end
end
