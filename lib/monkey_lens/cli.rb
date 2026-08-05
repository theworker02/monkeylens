# frozen_string_literal: true

require "optparse"
require_relative "../monkey_lens"

module MonkeyLens
  class CLI
    class << self
      def run(argv, out: $stdout, err: $stderr)
        new(argv, out:, err:).run
      end
    end

    def initialize(argv, out:, err:)
      @argv = argv.dup
      @out = out
      @err = err
    end

    def run
      command = @argv.shift
      case command
      when "capture" then capture
      when "check" then check
      when "diff" then diff
      when "inspect" then inspect_target
      when "doctor" then doctor
      when "version", "--version", "-v" then version
      when nil, "help", "--help", "-h" then help
      else
        @err.puts "Unknown command: #{command}"
        help(@err)
        2
      end
    rescue OptionParser::ParseError, MonkeyLens::Error, Errno::ENOENT => error
      @err.puts "MonkeyLens error: #{error.message}"
      2
    end

    private

    def capture
      options = common_options.merge(output: ".monkeylens.json")
      parser = parser_for("capture", options) do |opts|
        opts.on("-o", "--output PATH", "Snapshot output path") { |value| options[:output] = value }
      end
      parser.parse!(@argv)
      config = load_runtime(options)
      snapshot = MonkeyLens.capture(targets: config.targets, ignore_methods: config.ignore_methods)
      snapshot.write(options[:output])
      @out.puts "Captured #{snapshot.targets.length} target(s) to #{options[:output]}"
      0
    end

    def check
      options = common_options.merge(baseline: nil, format: nil, fail_on: nil)
      parser = parser_for("check", options) do |opts|
        opts.on("-b", "--baseline PATH", "Baseline path") { |value| options[:baseline] = value }
        opts.on("-f", "--format FORMAT", %w[text json sarif], "Report format") { |value| options[:format] = value }
        opts.on("--fail-on LEVEL", Config::LEVELS, "Failure threshold") { |value| options[:fail_on] = value }
      end
      parser.parse!(@argv)
      config = load_runtime(options)
      baseline = Snapshot.read(options[:baseline] || config.baseline)
      current = MonkeyLens.capture(targets: config.targets, ignore_methods: config.ignore_methods)
      result = MonkeyLens.diff(baseline, current)
      format = options[:format] || config.format
      @out.puts Formatter.render(result, format:)
      result.failure?(options[:fail_on] || config.fail_on) ? 1 : 0
    end

    def diff
      options = {format: "text", fail_on: nil}
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: monkeylens diff BASELINE CURRENT [options]"
        opts.on("-f", "--format FORMAT", %w[text json sarif]) { |value| options[:format] = value }
        opts.on("--fail-on LEVEL", Config::LEVELS) { |value| options[:fail_on] = value }
      end
      parser.parse!(@argv)
      baseline_path, current_path = @argv
      raise OptionParser::MissingArgument, "BASELINE and CURRENT are required" unless baseline_path && current_path

      result = MonkeyLens.diff(Snapshot.read(baseline_path), Snapshot.read(current_path))
      @out.puts Formatter.render(result, format: options[:format])
      options[:fail_on] && result.failure?(options[:fail_on]) ? 1 : 0
    end

    def inspect_target
      options = common_options
      parser = parser_for("inspect", options)
      parser.parse!(@argv)
      target = @argv.shift
      raise OptionParser::MissingArgument, "TARGET is required" unless target

      load_requires(options[:requires])
      snapshot = MonkeyLens.capture(targets: [target])
      record = snapshot.targets.fetch(target)
      @out.puts "#{target} (#{record.fetch("kind")})"
      @out.puts "Ancestors: #{record.fetch("ancestors").join(" -> ")}"
      record.fetch("instance_methods").each do |name, method|
        @out.puts "  ##{name} [#{method.fetch("visibility")}] owner=#{method.fetch("owner")} source=#{method.fetch("source_location")&.join(":") || "native"}"
      end
      0
    end

    def doctor
      options = common_options
      parser_for("doctor", options).parse!(@argv)
      config = Config.load(options[:config])
      @out.puts "MonkeyLens #{VERSION}"
      @out.puts RUBY_DESCRIPTION
      @out.puts "Config: #{options[:config]}"
      @out.puts "Baseline: #{File.exist?(config.baseline) ? config.baseline : "not found"}"
      0
    end

    def version
      @out.puts VERSION
      0
    end

    def help(io = @out)
      io.puts <<~HELP
        MonkeyLens #{VERSION} — make Ruby runtime patches visible

        Usage: monkeylens COMMAND [options]

        Commands:
          capture   Capture a runtime baseline
          check     Compare the current runtime against a baseline
          diff      Compare two saved snapshots
          inspect   Explain a target's effective method table
          doctor    Validate configuration and runtime support
          version   Print the installed version
      HELP
      0
    end

    def common_options
      {config: ".monkeylens.yml", requires: []}
    end

    def parser_for(command, options)
      OptionParser.new do |opts|
        opts.banner = "Usage: monkeylens #{command} [options]"
        opts.on("-c", "--config PATH", "Configuration path") { |value| options[:config] = value }
        opts.on("-r", "--require PATH", "Require an application file before capture") { |value| options[:requires] << value }
        yield opts if block_given?
      end
    end

    def load_runtime(options)
      config = Config.load(options[:config])
      load_requires(config.requires + options[:requires])
      config
    end

    def load_requires(paths)
      paths.each do |path|
        expanded = File.expand_path(path)
        require expanded
      end
    end
  end
end
