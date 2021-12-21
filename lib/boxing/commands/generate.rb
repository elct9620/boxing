# frozen_string_literal: true

require 'pathname'
require 'set'

module Boxing
  # :nodoc:
  module Commands
    # The Dockerfle Generator
    #
    # @since 0.1.0
    class Generate < Thor::Group
      include Thor::Actions

      # :nodoc:
      def self.source_root
        Pathname.new(File.dirname(__FILE__)).join('../../..')
      end

      # Create Dockerfile
      #
      # @since 0.1.0
      def execute
        template('templates/Dockerfile.tt', 'Dockerfile', context: context.to_binding)
        template('templates/dockerignore.tt', '.dockerignore', context: context.to_binding)
      end

      private

      def context
        @context = Context.new(
          Database.new,
          Boxing.dependencies
        )
      end
    end

    Boxing::Command.register(Generate, 'generate', 'generate', 'Generate Dockerfile')
  end
end
