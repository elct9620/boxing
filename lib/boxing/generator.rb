# frozen_string_literal: true

require 'tempfile'

module Boxing
  # Generate file from template
  #
  # @since 0.11.0
  class Generator
    ASCII_CLEAR = "\e[0m"
    ASCII_BOLD = "\e[1m"
    ASCII_RED = "\e[31m"

    CREATED_MESSAGE = "#{ASCII_BOLD}create#{ASCII_CLEAR}\t%s"
    IDENTICAL_MESSAGE = "#{ASCII_BOLD}identical#{ASCII_CLEAR}\t%s"
    CONFLICT_MESSAGE = "#{ASCII_BOLD}#{ASCII_RED}conflict#{ASCII_CLEAR}\t%s"
    OVERWRITE_MESSAGE = 'Overwrite %s? (enter "h" for help) [Ynqdhm] '
    FORCE_MESSAGE = "#{ASCII_BOLD}force#{ASCII_CLEAR}\t%s"
    SKIP_MESSAGE = "#{ASCII_BOLD}skip#{ASCII_CLEAR}\t%s"
    MERGE_TOOL_NOT_FOUND = 'Please configure merge.tool in your Git config.'

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
      return puts format(IDENTICAL_MESSAGE, destination) if identical?

      puts format(CONFLICT_MESSAGE, destination)
      return puts format(SKIP_MESSAGE, destination) unless do_overwrite

      puts format(FORCE_MESSAGE, destination)
      yield if block_given?
    end

    # Do overwrite
    #
    # @return [TrueClass|FalseClass]
    # @raise [SystemExit] if user quits
    #
    # @api private
    # @since 0.11.0
    def do_overwrite # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
      loop do
        print format(OVERWRITE_MESSAGE, destination)

        case $stdin.gets.chomp
        when 'Y', 'y', '' then return true
        when 'n', 'N' then return false
        when 'd', 'D' then show_diff
        when 'h', 'H' then show_help
        when 'm', 'M'
          puts MERGE_TOOL_NOT_FOUND unless do_merge
          return false
        when 'q', 'Q' then raise SystemExit
        end
      end
    end

    # Show diff
    #
    # @since 0.11.0
    # @api private
    def show_diff
      Tempfile.open(destination) do |tempfile|
        tempfile.write(render)
        tempfile.rewind

        system("diff -u #{tempfile.path} #{path}")
      end
    end

    # Do merge
    #
    # @return [TrueClass|FalseClass]
    #
    # @since 0.11.0
    # @api private
    def do_merge # rubocop:disable Metrics/MethodLength
      tool = begin
        `git config merge.tool`.rstrip
      rescue StandardError
        ''
      end
      return false if tool.empty?

      Tempfile.open(destination) do |tempfile|
        tempfile.write(render)
        tempfile.rewind

        system("#{tool} #{tempfile.path} #{path}")
      end
    end

    # Show help
    #
    # @since 0.11.0
    # @api private
    def show_help
      puts <<-HELP
        Y - yes, overwrite
        n - no, do not overwrite
        d - diff, show the differences between the old and the new
        h - help, show this help
        m - merge, run merge tool
        q - quit, exit this program
      HELP
    end
  end
end
