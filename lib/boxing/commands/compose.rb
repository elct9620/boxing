# frozen_string_literal: true

module Boxing
  # :nodoc:
  module Commands
    # The Docker Compose Generator
    #
    # @since 0.1.0
    class Compose < Base
      # Create Dockerfile
      #
      # @since 0.1.0
      def execute
        Database.download! unless Database.exist?

        # TODO: Allow set image registry
        # TODO: Allow set application name
        template('templates/docker-compose.yml.tt', 'docker-compose.yml', context: context.to_binding)
      end
    end

    Boxing::Command.register(Compose, 'compose', 'compose', 'Generate docker-compose.yml')
  end
end
