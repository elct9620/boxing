# frozen_string_literal: true

require 'pathname'

module Boxing
  # Utility methods
  #
  # @since 0.11.0
  module Utils
    # Get project root
    #
    # @return [String]
    #
    # @since 0.11.0
    def current_path
      return Bundler.root if defined?(Bundler)
      return Rails.root if defined?(Rails)
      return Hanami.app.root if defined?(Hanami)

      Pathname.new(Dir.pwd)
    end
  end
end
