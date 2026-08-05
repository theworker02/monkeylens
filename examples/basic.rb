# frozen_string_literal: true

require "monkey_lens"

baseline = MonkeyLens.capture(targets: ["String", "Array"])

module ExampleStringPatch
  def monkey_lens_example
    true
  end
end

String.prepend(ExampleStringPatch)

current = MonkeyLens.capture(targets: ["String", "Array"])
result = MonkeyLens.diff(baseline, current)

puts result.to_text
