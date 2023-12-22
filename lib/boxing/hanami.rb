# frozen_string_literal: true

Hanami::CLI::RakeTasks.register_tasks do
  namespace :boxing do
    load 'boxing/tasks/config.rake'
    load 'boxing/tasks/generate.rake'
    load 'boxing/tasks/update.rake'
  end
end
