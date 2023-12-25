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
  end
end
