# frozen_string_literal: true

module Boxing
  # :nodoc:
  module Commands
    # The Base Command
    #
    # @since 0.5.0
    class Base < Thor::Group
      include Thor::Actions

      # :nodoc:
      def self.source_root
        Pathname.new(File.dirname(__FILE__)).join('../../..')
      end

      # Prepare command environment
      #
      # @since 0.5.0
      def prepare
        config = Bundler.root.join('config/boxing.rb')
        return unless config.exist?

        load config
      end
    end
  end
end
