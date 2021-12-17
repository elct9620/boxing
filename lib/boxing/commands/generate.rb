# frozen_string_literal: true

require 'pathname'
require 'set'

module Boxing
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
        template('templates/Dockerfile.tt', 'Dockerfile')
      end

      private

      # Return loaded packages
      #
      # @return [Set<Boxing::Package>] packages
      #
      # @since 0.1.0
      def packages
        @packages ||=
          Set.new(
            Boxing
          .dependencies
          .map(&:name)
          .flat_map { |name| database.package_for(name).to_a }
          )
      end

      # @return [Boxing::Database]
      #
      # @since 0.1.0
      def database
        @database ||= Database.new
      end
    end

    Boxing::Command.register(Generate, 'generate', 'generate', 'Generate Dockerfile')
  end
end
