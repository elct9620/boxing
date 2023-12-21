# frozen_string_literal: true

module Boxing
  # :nodoc:
  class Railtie < ::Rails::Railtie
    rake_tasks do
      namespace :boxing do
        load 'boxing/tasks/update.rake'
      end
    end
  end
end
