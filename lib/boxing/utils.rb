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
      return Hanami.app.root if defined?(Hanami)
      return Rails.root if defined?(Rails)

      Pathname.new(Dir.pwd)
    end

    # Generate file from template
    #
    # @param [String] destination
    # @param [String] template
    # @param [Binding] context
    #
    # @since 0.11.0
    def template(destination, template, context: nil)
      Generator.new(destination, -> { Template.new(template).render(context) }).execute
    end
  end
end
