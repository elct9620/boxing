# frozen_string_literal: true

require 'pathname'
require 'boxing/package'

module Boxing
  # The package and dependency mapping database
  #
  # @since 0.1.0
  class Database
    class << self
      # Check for the database exists
      #
      # @param [String] path
      #
      # @return [TrueClass\FalseClass]
      #
      # @since 0.3.0
      def exist?(path = DEFAULT_PATH)
        File.directory?(path) && !(Dir.entries(path) - %w[. ..]).empty?
      end

      # Download Database
      #
      # @since 0.3.0
      def download!(path = DEFAULT_PATH)
        command = %w[git clone --quiet]
        command << URL << path.to_s

        raise DownloadFailed, "failed to download #{URL} to #{path}" unless system(*command)

        new(path)
      end
    end

    # @since 0.3.0
    class DownloadFailed < RuntimeError; end

    # @since 0.3.0
    class UpdateFailed < RuntimeError; end

    # Git URL of the ruby-boxing-db
    #
    # @since 0.3.0
    URL = 'https://github.com/elct9620/ruby-boxing-db.git'

    # Path to the user's copy of ruby-boxing-db
    #
    # @since 0.3.0
    USER_PATH = Pathname.new(Gem.user_home).join('.local/share/ruby-boxing-db')

    # @since 0.3.0
    DEFAULT_PATH = ENV.fetch('BOXING_DB', USER_PATH)

    # @since 0.3.0
    attr_reader :path

    # Initialize Database
    #
    # @since 0.3.0
    def initialize(path = DEFAULT_PATH)
      @path = path
    end

    # The Database is Git Repoistory
    #
    # @return [TrueClass|FalseClass]
    #
    # @since 0.3.0
    def git?
      File.directory?(File.join(@path, '.git'))
    end

    # Update the database
    #
    # @since 0.3.0
    def update!
      return unless git?

      Dir.chdir(@path) do
        command = %w[git pull --quiet origin main]
        raise UpdateFailed, "failed to update #{@path}" unless system(*command)
      end

      true
    end

    # Find packages for rubygems
    #
    # @param name [String] the gem name
    #
    # @yield [path] The given block will be passed each package path
    # @yieldparam [Boxing::Package] The package related rubygem
    #
    # @since 0.1.0
    def package_for(name)
      return enum_for(__method__, name) unless block_given?

      each_package_path_for(name.to_s) do |path|
        yield Package.load(path)
      end
    end

    # Enumerates over gems
    #
    # @param name [String] the gem name
    # @yield [path] The given block will be passed each package path
    # @yieldparam [String] A path to package `.yml` file
    #
    # @since 0.1.0
    def each_package_path_for(name, &block)
      Dir.glob(File.join(@path, 'gems', name, '*.yml'), &block)
    end
  end
end
