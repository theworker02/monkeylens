# frozen_string_literal: true

require "test_helper"
require "monkey_lens/cli"
require "tmpdir"

class CLITest < Minitest::Test
  def test_version
    out = StringIO.new
    assert_equal 0, MonkeyLens::CLI.run(["version"], out: out, err: StringIO.new)
    assert_equal "#{MonkeyLens::VERSION}\n", out.string
  end

  def test_capture_and_check
    Dir.mktmpdir do |directory|
      config = File.join(directory, "config.yml")
      baseline = File.join(directory, "baseline.json")
      File.write(config, "targets:\n  - MonkeyLensFixture\n")

      assert_equal 0, MonkeyLens::CLI.run(["capture", "--config", config, "--output", baseline], out: StringIO.new, err: StringIO.new)
      assert_equal 0, MonkeyLens::CLI.run(["check", "--config", config, "--baseline", baseline], out: StringIO.new, err: StringIO.new)
    end
  end
end
