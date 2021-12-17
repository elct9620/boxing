# frozen_string_literal: true

require 'pathname'
require 'boxing/package'

module Boxing
  # The package and dependency mapping database
  #
  # @since 0.1.0
  class Database
    class << self
      # The database root
      #
      # @since 0.1.0
      def root
        @root ||= Pathname.new(File.basename(__FILE__)).join('../database')
      end
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
      Dir.glob(Database.root.join('gems', name, '*.yml'), &block)
    end
  end
end
