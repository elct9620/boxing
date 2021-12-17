# frozen_string_literal: true

require 'thor'

module Boxing
  # The Main Command
  #
  # @since 0.1.0
  class Command < Thor
    # :nodoc:
    def self.exit_on_failure?
      true
    end

    require_relative 'commands/generate'
  end
end
