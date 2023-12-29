# frozen_string_literal: true

require 'rake'

module Boxing
  # The Main Command
  #
  # @since 0.1.0
  class Command < Rake::Application
    # @since 0.11.0
    TASK_ROOT = File.expand_path('./tasks', __dir__)

    # @see Rake::Application#run
    def run(argv = ARGV)
      standard_exception_handling do
        init('boxing', argv)
        load_rakefile
        top_level
      end
    end

    # @see Rake::Application#load_rakefile
    def load_rakefile
      glob("#{TASK_ROOT}/**/*.rake").each { |task| add_import task }
      load_imports
    end
  end
end
