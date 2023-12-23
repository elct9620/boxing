# frozen_string_literal: true

module Boxing
  # :nodoc:
  class Railtie < ::Rails::Railtie
    rake_tasks do
      namespace :boxing do
        load 'boxing/tasks/config.rake'
        load 'boxing/tasks/generate.rake'
        load 'boxing/tasks/update.rake'
        load 'boxing/tasks/compose.rake'
      end
    end
  end
end
