# frozen_string_literal: true

module MonkeyLens
  class Railtie < Rails::Railtie
    rake_tasks do
      require "monkey_lens/rake_task"
      MonkeyLens::RakeTask.new
    end
  end
end
