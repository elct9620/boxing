# frozen_string_literal: true

module Boxing
  # :nodoc:
  module Commands
    # The Database Updater
    #
    # @since 0.3.0
    class Update < Thor::Group
      # Update Database
      #
      # @since 0.3.0
      def execute
        if Database.exist?
          Database.new.update!
        else
          Database.download!
        end
      end
    end

    Boxing::Command.register(Update, 'update', 'update', 'Update Database')
  end
end
