# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "minitest/autorun"
require "stringio"
require "monkey_lens"

class MonkeyLensFixture
  def greet(name)
    "hello #{name}"
  end
end
