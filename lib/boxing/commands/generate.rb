# frozen_string_literal: true

require 'pathname'
require 'set'

module Boxing
  # :nodoc:
  module Commands
    # The Dockerfle Generator
    #
    # @since 0.1.0
    class Generate < Base
      # Create Dockerfile
      #
      # @since 0.1.0
      def execute
        Database.download! unless Database.exist?

        template('templates/Dockerfile.tt', 'Dockerfile', context: context.to_binding)
        template('templates/dockerignore.tt', '.dockerignore', context: context.to_binding)
      end
    end

    Boxing::Command.register(Generate, 'generate', 'generate', 'Generate Dockerfile')
  end
end
