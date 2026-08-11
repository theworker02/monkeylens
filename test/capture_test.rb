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

  def test_provenance_is_opt_in
    without = MonkeyLens.capture(targets: ["MonkeyLensFixture"])
    method = without.targets.fetch("MonkeyLensFixture").fetch("instance_methods").fetch("greet")
    refute method.key?("provenance")

    with = MonkeyLens.capture(targets: ["MonkeyLensFixture"], provenance: true)
    provenance = with.targets.fetch("MonkeyLensFixture").fetch("instance_methods").fetch("greet").fetch("provenance")

    assert_equal "app", provenance.fetch("kind")
    assert_match(/test_helper\.rb/, provenance.fetch("path"))
  end

  def test_provenance_classifies_eval_source
    location = ["(eval)", 1]
    provenance = MonkeyLens::Provenance.for_source_location(location)

    assert_equal "eval", provenance.kind
    assert_nil provenance.gem
  end
end
