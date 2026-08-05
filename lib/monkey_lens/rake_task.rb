# frozen_string_literal: true

require "rake"
require "monkey_lens/cli"

module MonkeyLens
  class RakeTask
    attr_accessor :name, :config, :baseline

    def initialize(name = :monkey_lens)
      @name = name
      @config = ".monkeylens.yml"
      @baseline = ".monkeylens.json"
      yield self if block_given?
      define_tasks
    end

    private

    def define_tasks
      namespace name do
        desc "Capture a MonkeyLens runtime baseline"
        task :capture do
          status = CLI.run(["capture", "--config", config, "--output", baseline])
          abort "MonkeyLens capture failed" unless status.zero?
        end

        desc "Check the current Ruby runtime against the MonkeyLens baseline"
        task :check do
          status = CLI.run(["check", "--config", config, "--baseline", baseline])
          abort "MonkeyLens detected runtime drift" unless status.zero?
        end
      end
    end
  end
end
