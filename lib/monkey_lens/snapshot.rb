# frozen_string_literal: true

require "json"

module MonkeyLens
  class Snapshot
    SCHEMA = 1

    attr_reader :schema, :ruby, :engine, :targets

    def initialize(schema: SCHEMA, ruby:, engine:, targets:)
      @schema = Integer(schema)
      @ruby = ruby.to_s
      @engine = engine.to_s
      @targets = targets.transform_keys(&:to_s)
      validate!
    end

    def self.read(path)
      data = JSON.parse(File.read(path))
      new(
        schema: data.fetch("schema"),
        ruby: data.fetch("ruby"),
        engine: data.fetch("engine"),
        targets: data.fetch("targets")
      )
    rescue JSON::ParserError, KeyError => error
      raise SnapshotError, "invalid snapshot #{path}: #{error.message}"
    end

    def write(path)
      File.write(path, "#{JSON.pretty_generate(to_h)}\n")
      self
    end

    def to_h
      {
        "schema" => schema,
        "ruby" => ruby,
        "engine" => engine,
        "targets" => targets.sort.to_h
      }
    end

    private

    def validate!
      raise SnapshotError, "unsupported snapshot schema #{schema}" unless schema == SCHEMA
      raise SnapshotError, "snapshot targets must be an object" unless targets.is_a?(Hash)
    end
  end
end
