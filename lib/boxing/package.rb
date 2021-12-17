# frozen_string_literal: true

require 'yaml'

module Boxing
  # The rubygems mapping for Linux package
  #
  # @since 0.1.0
  class Package
    class << self
      # Load Required Packages
      #
      # @return [Boxing::Package]
      #
      # @since 0.1.0
      def load(path)
        data = YAML.safe_load(File.read(path))
        mode = 0b00
        mode |= Package::RUNTIME if data['runtime']
        mode |= Package::BUILD if data['build']
        new(data['name'], data['version'], mode: mode)
      end
    end

    # @since 0.1.0
    RUNTIME = 0b01

    # @since 0.1.0
    BUILD = 0b10

    # @since 0.1.0
    attr_reader :name, :version

    # @param name [String] the package name
    # @param version [String] the package version
    # @param mode [Number] is runtime or build
    #
    # @since 0.1.0
    def initialize(name, version = nil, mode: RUNTIME)
      @name = name
      @version = version
      @mode = mode
    end

    # @return [TrueClass|FalseClass] is for build
    #
    # @since 0.1.0
    def build?
      @mode & BUILD == BUILD
    end

    # @return [TrueClass|FalseClass] is for runtime
    #
    # @since 0.1.0
    def runtime?
      @mode & RUNTIME == RUNTIME
    end

    # Compare is same package
    #
    # @return [TrueClass|FalseClass]
    #
    # @since 0.1.0
    def eql?(other)
      @name == other.name
    end
    alias == eql?

    # Return Object#hash
    #
    # @return [Number]
    #
    # @since 0.1.0
    def hash
      @name.hash
    end

    # Convert to string
    #
    # @return [String] the package string
    #
    # @since 0.1.0
    def to_s
      return @name if @version.nil?

      # NOTE: Alpine format only
      "#{@name}=#{@version}"
    end
  end
end
