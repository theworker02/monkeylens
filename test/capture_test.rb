# frozen_string_literal: true

require "test_helper"

class CaptureTest < Minitest::Test
  def test_captures_method_owner_signature_and_source
    snapshot = MonkeyLens.capture(targets: ["MonkeyLensFixture"])
    method = snapshot.targets.fetch("MonkeyLensFixture").fetch("instance_methods").fetch("greet")

    assert_equal "MonkeyLensFixture", method.fetch("owner")
    assert_equal [["req", "name"]], method.fetch("parameters")
    assert_equal 1, method.fetch("arity")
    assert_equal "public", method.fetch("visibility")
    assert_match(/test_helper\.rb/, method.fetch("source_location").first)
  end

  def test_capture_is_deterministic
    first = MonkeyLens.capture(targets: ["MonkeyLensFixture"]).to_h
    second = MonkeyLens.capture(targets: ["MonkeyLensFixture"]).to_h

    assert_equal first, second
  end
end
