# frozen_string_literal: true

module Boxing
  # Generate file from template
  #
  # @since 0.11.0
  class Generator
    ASCII_CLEAR = "\e[0m"
    ASCII_BOLD = "\e[1m"

    CREATED_MESSAGE = "#{ASCII_BOLD}create#{ASCII_CLEAR}\t%s"
    IDENTICAL_MESSAGE = "#{ASCII_BOLD}identical#{ASCII_CLEAR}\t%s"
    CONFLICT_MESSAGE = "#{ASCII_BOLD}conflict#{ASCII_CLEAR}\t%s"

    attr_reader :destination, :path

    include Utils

    # @since 0.11.0
    def initialize(destination, content)
      @destination = destination
      @path = current_path.join(@destination)
      @content = content
    end

    # Generate file
    #
    # @since 0.11.0
    def execute
      with_conflict do
        FileUtils.mkdir_p(File.dirname(path))
        File.write(path, render)
      end
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
      path.exist?
    end

    # Check if file identical
    #
    # @return [TrueClass|FalseClass]
    #
    # @since 0.11.0
    def identical?
      exist? && File.binread(path) == String.new(render).force_encoding('ASCII-8BIT')
    end

    protected

    # With conflict
    #
    # @param [Proc] block
    #
    # @since 0.11.0
    def with_conflict(&block)
      return on_conflict(&block) if exist?

      yield
      puts format(CREATED_MESSAGE, destination)
    end

    # On conflict
    #
    # @param [Proc] block
    #
    # @since 0.11.0
    def on_conflict
      if identical?
        puts format(IDENTICAL_MESSAGE, destination)
        return
      end

      puts format(CONFLICT_MESSAGE, destination)
    end
  end
end
