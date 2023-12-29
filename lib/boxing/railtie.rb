# frozen_string_literal: true

module Boxing
  # :nodoc:
  class Railtie < ::Rails::Railtie
    rake_tasks do
      namespace :boxing do
        path = File.join(Boxing::Command::TASK_ROOT, '**/*.rake')
        FileList.glob(path.tr('\\', '/')).each { |file| load file }
      end
    end
  end
end
