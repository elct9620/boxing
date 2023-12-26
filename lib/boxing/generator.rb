# frozen_string_literal: true

module Boxing
  # Generate file from template
  #
  # @since 0.11.0
  class Generator
    include Utils

    # @since 0.11.0
    def initialize(destination, content)
      pp current_path
      @destination = current_path.join(destination)
      @content = content
    end

    # Generate file
    #
    # @since 0.11.0
    def execute
      return if identical?

      FileUtils.mkdir_p(File.dirname(@destination))
      File.write(@destination, render)
    end

    # Render content
    #
    # @return [String]
    #
    # @since 0.11.0
    def render
      @render ||= if @content.is_a?(Proc)
                    @content.call
                  else
                    @content
                  end
    end

    # Check if file exists
    #
    # @return [TrueClass|FalseClass]
    #
    # @since 0.11.0
    def exist?
      @destination.exist?
    end

    # Check if file identical
    #
    # @return [TrueClass|FalseClass]
    #
    # @since 0.11.0
    def identical?
      exist? && File.binread(@destination) == String.new(render).force_encoding('ASCII-8BIT')
    end
  end
end
