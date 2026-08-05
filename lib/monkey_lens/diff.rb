# frozen_string_literal: true

module MonkeyLens
  class Diff
    class Result
      attr_reader :baseline, :current, :changes

      def initialize(baseline:, current:, changes:)
        @baseline = baseline
        @current = current
        @changes = changes.sort_by { |change| [-change.level, change.target, change.method_id.to_s, change.type] }
      end

      def clean?
        changes.empty?
      end

      def failure?(threshold)
        minimum = Change::LEVELS.fetch(threshold.to_s)
        changes.any? { |change| change.level >= minimum }
      end

      def to_h
        {
          "schema" => 1,
          "clean" => clean?,
          "summary" => Change::LEVELS.keys.to_h { |level| [level, changes.count { |change| change.severity == level }] },
          "changes" => changes.map(&:to_h)
        }
      end

      def to_text
        Formatter::Text.new(self).render
      end
    end

    def initialize(baseline:, current:)
      @baseline = baseline
      @current = current
    end

    def call
      changes = []
      target_names = (@baseline.targets.keys | @current.targets.keys).sort
      target_names.each { |target| compare_target(target, changes) }
      Result.new(baseline: @baseline, current: @current, changes:)
    end

    private

    def compare_target(target, changes)
      before = @baseline.targets[target]
      after = @current.targets[target]

      unless before
        changes << change("target_added", "low", target, message: "target entered the runtime snapshot", after:)
        return
      end
      unless after
        changes << change("target_removed", "critical", target, message: "target disappeared from the runtime snapshot", before:)
        return
      end

      if before.fetch("ancestors") != after.fetch("ancestors")
        changes << change(
          "ancestor_chain_changed",
          "high",
          target,
          before: before.fetch("ancestors"),
          after: after.fetch("ancestors"),
          message: "ancestor/prepend order changed"
        )
      end

      compare_methods(target, "instance_methods", "#", before, after, changes)
      compare_methods(target, "singleton_methods", ".", before, after, changes)
    end

    def compare_methods(target, key, separator, before_target, after_target, changes)
      before_methods = before_target.fetch(key)
      after_methods = after_target.fetch(key)
      (before_methods.keys | after_methods.keys).sort.each do |name|
        method_id = "#{target}#{separator}#{name}"
        before = before_methods[name]
        after = after_methods[name]

        unless before
          changes << change("method_added", "low", target, method_id:, after:, message: "method was added")
          next
        end
        unless after
          changes << change("method_removed", "high", target, method_id:, before:, message: "method was removed")
          next
        end

        compare_method_fields(target, method_id, before, after, changes)
      end
    end

    def compare_method_fields(target, method_id, before, after, changes)
      if before.fetch("owner") != after.fetch("owner")
        changes << change("owner_changed", "critical", target, method_id:, before: before.fetch("owner"), after: after.fetch("owner"), message: "effective method owner changed")
      end
      if before.fetch("source_location") != after.fetch("source_location")
        changes << change("source_changed", "high", target, method_id:, before: before.fetch("source_location"), after: after.fetch("source_location"), message: "method implementation source changed")
      end
      if before.fetch("parameters") != after.fetch("parameters") || before.fetch("arity") != after.fetch("arity")
        changes << change("signature_changed", "medium", target, method_id:, before: signature(before), after: signature(after), message: "method signature changed")
      end
      if before.fetch("visibility") != after.fetch("visibility")
        changes << change("visibility_changed", "medium", target, method_id:, before: before.fetch("visibility"), after: after.fetch("visibility"), message: "method visibility changed")
      end
    end

    def signature(method)
      {"parameters" => method.fetch("parameters"), "arity" => method.fetch("arity")}
    end

    def change(type, severity, target, method_id: nil, before: nil, after: nil, message:)
      Change.new(type:, severity:, target:, method_id:, before:, after:, message:)
    end
  end
end
