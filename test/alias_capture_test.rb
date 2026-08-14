# frozen_string_literal: true

require "test_helper"

class AliasCaptureTest < Minitest::Test
  class AliasFixture
    def greet(name)
      "hello #{name}"
    end
    alias hello greet
  end

  class AliasAddFixture
    def greet(name)
      "hello #{name}"
    end
    alias hello greet
  end

  class SuperFixture
    def greet(name)
      "base #{name}"
    end
  end

  def test_captures_aliases_and_original_name
    snapshot = MonkeyLens.capture(targets: ["AliasCaptureTest::AliasFixture"])
    greet = snapshot.targets.fetch("AliasCaptureTest::AliasFixture").fetch("instance_methods").fetch("greet")
    hello = snapshot.targets.fetch("AliasCaptureTest::AliasFixture").fetch("instance_methods").fetch("hello")

    assert_equal "greet", greet.fetch("original_name")
    assert_equal ["hello"], greet.fetch("aliases")
    assert_equal "greet", hello.fetch("original_name")
    assert_equal ["greet"], hello.fetch("aliases")
  end

  def test_diff_detects_new_alias
    baseline = MonkeyLens.capture(targets: ["AliasCaptureTest::AliasAddFixture"])
    AliasCaptureTest::AliasAddFixture.class_eval { alias_method :welcome, :greet }
    current = MonkeyLens.capture(targets: ["AliasCaptureTest::AliasAddFixture"])
    result = MonkeyLens.diff(baseline, current)

    assert result.changes.any? { |change|
      change.type == "alias_changed" && change.method_id == "AliasCaptureTest::AliasAddFixture#greet"
    }
    assert result.changes.any? { |change| change.type == "method_added" && change.method_id&.end_with?("#welcome") }
  end

  def test_diff_detects_super_owner_change
    baseline = MonkeyLens.capture(targets: ["AliasCaptureTest::SuperFixture"])
    patch = Module.new do
      def greet(name)
        "patched #{super}"
      end
    end
    AliasCaptureTest::SuperFixture.prepend(patch)
    current = MonkeyLens.capture(targets: ["AliasCaptureTest::SuperFixture"])
    result = MonkeyLens.diff(baseline, current)

    assert result.changes.any? { |change|
      change.type == "super_owner_changed" && change.method_id == "AliasCaptureTest::SuperFixture#greet"
    }
  end
end
