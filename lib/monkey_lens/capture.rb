# frozen_string_literal: true

require "set"

module MonkeyLens
  class Capture
    VISIBILITIES = %i[public protected private].freeze

    def initialize(targets:, ignore_methods: [])
      @targets = targets
      @ignore_methods = ignore_methods.to_set
    end

    def call
      records = @targets.sort.to_h do |target_name|
        target = constantize(target_name)
        [target_name, capture_target(target_name, target)]
      end

      Snapshot.new(
        schema: Snapshot::SCHEMA,
        ruby: RUBY_DESCRIPTION,
        engine: defined?(RUBY_ENGINE) ? RUBY_ENGINE : "ruby",
        targets: records
      )
    end

    private

    def constantize(name)
      constant = name.split("::").reject(&:empty?).inject(Object) { |scope, part| scope.const_get(part, false) }
      return constant if constant.is_a?(Module)

      raise ConfigurationError, "#{name} is not a class or module"
    rescue NameError => error
      raise ConfigurationError, "cannot resolve target #{name}: #{error.message}"
    end

    def capture_target(name, target)
      {
        "kind" => target.is_a?(Class) ? "class" : "module",
        "ancestors" => target.ancestors.map { |ancestor| constant_name(ancestor) },
        "instance_methods" => capture_methods(name, target, singleton: false),
        "singleton_methods" => capture_methods(name, target.singleton_class, singleton: true)
      }
    end

    def capture_methods(target_name, receiver, singleton:)
      names = VISIBILITIES.flat_map { |visibility| receiver.public_send("#{visibility}_instance_methods", true) }.uniq

      names.sort_by(&:to_s).filter_map do |method_name|
        identifier = singleton ? "#{target_name}.#{method_name}" : "#{target_name}##{method_name}"
        next if @ignore_methods.include?(identifier)

        method = receiver.instance_method(method_name)
        visibility = VISIBILITIES.find { |candidate| receiver.public_send("#{candidate}_method_defined?", method_name) }

        [method_name.to_s, {
          "owner" => constant_name(method.owner),
          "visibility" => visibility.to_s,
          "parameters" => method.parameters.map { |kind, parameter| [kind.to_s, parameter&.to_s] },
          "arity" => method.arity,
          "source_location" => normalize_source(method.source_location)
        }]
      rescue NameError
        nil
      end.to_h
    end

    def constant_name(value)
      value.name || value.inspect
    end

    def normalize_source(location)
      return nil unless location

      path, line = location
      [normalize_path(path), line]
    end

    def normalize_path(path)
      absolute = File.expand_path(path)
      cwd = File.expand_path(Dir.pwd)
      absolute.start_with?("#{cwd}/") ? absolute.delete_prefix("#{cwd}/") : absolute
    end
  end
end
