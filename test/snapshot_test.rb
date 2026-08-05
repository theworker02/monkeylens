# frozen_string_literal: true

require "test_helper"
require "tmpdir"

class SnapshotTest < Minitest::Test
  def test_round_trip
    snapshot = MonkeyLens.capture(targets: ["Array"])

    Dir.mktmpdir do |directory|
      path = File.join(directory, "snapshot.json")
      snapshot.write(path)
      restored = MonkeyLens::Snapshot.read(path)

      assert_equal snapshot.to_h, restored.to_h
    end
  end
end
