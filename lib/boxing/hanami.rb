# frozen_string_literal: true

Hanami::CLI::RakeTasks.register_tasks do
  namespace :boxing do
    path = File.join(Boxing::Command::TASK_ROOT, '**/*.rake')
    FileList.glob(path.tr('\\', '/')).each { |file| load file }
  end
end
