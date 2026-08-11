# frozen_string_literal: true

module MonkeyLens
  class Provenance
    KINDS = %w[gem app stdlib eval unknown].freeze

    attr_reader :kind, :gem, :path, :line

    def initialize(kind:, gem: nil, path: nil, line: nil)
      @kind = kind.to_s
      @gem = gem
      @path = path
      @line = line
    end

    def self.for_source_location(location)
      return nil unless location

      path, line = location
      path = path.to_s
      line = Integer(line)
      kind, gem_name = classify(path)
      new(kind:, gem: gem_name, path: normalize_path(path), line:)
    end

    def self.classify(path)
      return ["eval", nil] if eval_path?(path)

      expanded = File.expand_path(path)
      gem_info = gem_for_path(expanded)
      return ["gem", gem_info] if gem_info

      if stdlib_path?(expanded)
        ["stdlib", nil]
      elsif app_path?(expanded)
        ["app", nil]
      else
        ["unknown", nil]
      end
    end

    def self.eval_path?(path)
      path.start_with?("(eval") || path == "eval"
    end

    def self.gem_for_path(path)
      Gem.loaded_specs.each_value do |spec|
        spec.full_require_paths.each do |require_path|
          expanded = File.expand_path(require_path)
          next unless path.start_with?("#{expanded}/") || path == expanded

          return spec.name
        end
      end
      nil
    end

    def self.stdlib_path?(path)
      ruby_root = RbConfig::CONFIG["rubylibdir"]
      return path.start_with?(ruby_root) if ruby_root

      path.include?("/ruby/") && path.include?("/lib/")
    end

    def self.app_path?(path)
      cwd = File.expand_path(Dir.pwd)
      path.start_with?("#{cwd}/") || path == cwd
    end

    def self.normalize_path(path)
      absolute = File.expand_path(path)
      cwd = File.expand_path(Dir.pwd)
      absolute.start_with?("#{cwd}/") ? absolute.delete_prefix("#{cwd}/") : absolute
    end

    def to_h
      {
        "kind" => kind,
        "gem" => gem,
        "path" => path,
        "line" => line
      }.compact
    end
  end
end
